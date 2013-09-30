var _ = require('lodash');
var $ = require('jquery');
var Backbone = require('backbone');

module.exports = {
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
      target = this.model;
    }
    else {
      throw new Error('Backbone.Smartclasses only works on bound Views.');
    }

    _(this.smartclasses).each(function(config, className) {
      if (!config.deps || !_.isArray(config.deps) || config.deps.length === 0) {
        throw new Error('deps[] must be specified for "' + className + '".');
      }
      var test;
      // If a test function has been specified, bind it to the target's context.
      if (config.test) {
        test = _.bind(config.test, target);
      }
      // otherwise, use the default test function and ensure it has access to
      // config.deps.
      else {
        test = _.bind(this.test, this, config.deps);
      }

      var setSmartclass = _.wrap(this.setSmartclass, test);

      // Then, bind test to each dependency.
      _(config.deps).each(function(dep) {
        this.listenTo(target, 'change:' + dep, setSmartclass);
      }, this);

    }, this);
  },

  test: function(deps) {
    // we need to provide an actual callback to `every()`, otherwise 0 evaluates
    // to false.
    return _(this.model.pick(deps)).values().every(this._test);
  },

  _test: function(value) {
    return value || value === 0;
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
