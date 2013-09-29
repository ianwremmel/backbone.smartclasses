var _ = require('underscore');
var $ = require('jquery');
var Backbone = require('backbone');

module.exports = {
  initialize: function() {
    _.each(this.smartclasses, _.bind(this._initSmartclass, this));
  },

  _initSmartclass: function(config, smartclass) {
    if (!data.deps || !_.isArray(data.deps) || data.depslength === 0) {
      throw new Error('deps[] must be specified for "' + smartclass + '"');
    }
    _.each(data.deps, _.bind(this._bindSmartclass, this));
  },

  _bindSmartclass: function(dep) {
    this.listenTo(this.model, 'change:' + dep, _.bind(this._testSmartclass, this, smartclass));
  },

  _testSmartclass: function(className) {
    var test = this.smartclasses[className].test;
    if (test) {
      return test();
    }
    else {
      // TODO check if any `deps` are truthy. I'm pretty sure there's lodash
      // function that'll make this easier.
    }
  },

  _setSmartclass: function(className) {
    if (test(className)) {
      this.$el.addClass(className);
    }
    else {
      this.$el.removeClass(className);
    }
  }
};
