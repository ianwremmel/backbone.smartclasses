(function(root, factory) {
    if(typeof exports === 'object') {
        module.exports = factory(require('backbone'), require('lodash'));
    }
    else if(typeof define === 'function' && define.amd) {
        define(['backbone', 'lodash'], factory);
    }
    else {
        root.smartclasses = factory(root.Backbone, root._);
    }
}(this, function(Backbone, _) {
var smartclasses = {
  initialize: function(options) {
    if (!(this instanceof Backbone.View)) {
      // TODO consider using a looser test for what can and cannot use
      // smartclasses. In theory, anything with a model or collection and an $el
      // should be able to use the mixin.
      throw new Error('Backbone.Smartclasses can only be applied to Backbone.View-like objects.');
    }

    if (options && options.smartclasses) {
      this.smartclasses = _.assign({}, this.smartclasses, options.smartclasses);
    }

    _.bindAll(this, 'setSmartclass');

    var target, test;
    if (this.model) {
      this._bindModel(this.model);
    }
    else if (this.collection) {
      this._bindCollection(this.collection);
    }
    else {
      throw new Error('Backbone.Smartclasses only works on bound Views.');
    }

    this.setClasses();
  },

  _bindModel: function(target) {
    this.smarttests = {};

    _(this.smartclasses).each(function(config, className) {
      if (!config.deps || !_.isArray(config.deps) || config.deps.length === 0) {
        throw new Error('deps[] must be specified for "' + className + '".');
      }
      var test;
      // If a test function has been specified, bind it to the target's context.
      if (config.test) {
        test = _.bind(config.test, this);
      }
      // otherwise, use the default test function and ensure it has access to
      // config.deps.
      else {
        test = _.bind(this.testDepsForTruthiness, this, config.deps);
      }

      var setSmartclass = _.bind(this.setSmartclass, this, test, className);

      this.smarttests[className] = setSmartclass;

      // Then, bind test to each dependency.
      _(config.deps).each(function(dep) {
        if (target.get(dep) instanceof Backbone.Collection) {
          this.listenTo(target.get(dep), 'add remove change', setSmartclass);
        }
        else {
          this.listenTo(target, 'change:' + dep, setSmartclass);
        }
      }, this);

    }, this);
  },

  _bindCollection: function(target) {
    this.smarttests = {};
    _(this.smartclasses).each(function(config, className) {
      var deps = config.deps || ['add', 'remove', 'change'];

      if (!config.test || typeof config.test !== 'function') {
        throw new Error('Missing test() for ' + className);
      }

      var test = _.bind(config.test, this);
      var setSmartclass = _.bind(this.setSmartclass, this, test, className);
      _(deps).each(function(dep) {
        this.listenTo(target, dep, setSmartclass);
      }, this);

    }, this);
  },

  setClasses: function() {
    _(this.smarttests).each(function(test){
      test.apply(this);
    }, this);
  },

  testDepsForTruthiness: function(deps) {
    // we need to provide an actual callback to `every()`, otherwise 0 evaluates
    // to false.
    if (deps.length === 1) {
      // TODO this needs a test
      return this._test(this.model.get(deps[0]));
    }
    else {
      return _(this.model.pick(deps)).values().every(this._test);
    }
  },

  _test: function(value) {
    return !!value || value === 0;
  },

  setSmartclass: function(test, className) {
    if (test()) {
      this.$el.addClass(className);
    }
    else {
      this.$el.removeClass(className);
    }
  }
};

    return smartclasses;
}));
