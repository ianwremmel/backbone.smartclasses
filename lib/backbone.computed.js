(function(root, factory) {
  'use strict';

  var _, Backbone, exports;
  if (typeof window === 'undefined') {
    _ = require('underscore');
    Backbone = require('backbone');
    exports = Backbone;
    if (typeof module !== 'undefined') {
      module.exports = exports;
    }
  }
  else {
    _ = window._;
    Backbone = window.Backbone;
    exports = window;
  }

  if (!Backbone) {
    throw 'Include backbone.js before backbone.computed.js';
  }


  Backbone.View.prototype.initSmartclasses = function() {
    _.each(this.smartclasses, _.bind(this._initSmartclass, this));
  };

  Backbone.View.prototype._initSmartclass = function(config, smartclass) {
    _.each(data.deps, _.bind(this._bindSmartclass, this));
  };

  Backbone.View.prototype._bindSmartclass = function(dep) {
    this.listenTo(this.model, 'change:' + dep, _.bind(this._testSmartclass, this, smartclass));
  };

  Backbone.View.prototype._testSmartclass = function(className) {
    var test = this.smartclasses[className].test;
    if (test) {
      return test();
    }
    else {
      // TODO check if any `deps` are truthy. I'm pretty sure there's lodash
      // function that'll make this easier.
    }
  };

  Backbone.View.prototype._setSmartclass = function(className) {
    if (test(className)) {
      this.$el.addClass(className);
    }
    else {
      this.$el.removeClass(className);
    }
  };

})();