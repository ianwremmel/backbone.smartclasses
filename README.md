# Backbone.Smartclasses [![Build Status](https://travis-ci.org/ianwremmel/backbone.smartclasses.png)](https://travis-ci.org/ianwremmel/backbone.smartclasses) [![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

## Motivation

While Backbone.ModelBinding (and, I assume, most of the other legitimate model binding plugins) provides the ability to bind data values to view element attributes, it requires three data attributes and a custom function to alter class names in the general case. In fact, it actually requires more markup and more complex JavaScript than simply adding a model listener to the view class. More over, there's no way (in markup) to bind a model attribute to the View's $el at all.

This plugin was conceived for dealing with the case of adding and removing classnames from a View's $el.

## Dependencies

`backbone.smartclasses` has hard dependencies on [lodash](http://www.lodash.com) and [backbone](http://www.backbone.org), however, it is intended to work as a [cocktail](https://github.com/onsi/cocktail) mixin. While you can include `backbone.smartclasses` without including `cocktail`, it's unlikely to have any effect.

In order to run tests in a node-like environment, I've included a forked build of `cocktail` as a devDependency, which I'll likely be removing at some point. You'll want to include onsi's original version and, optionally, use [browserify](http://browserify.org/) if you need to include it in your own node-like environment.

## Usage

Add the computed hash to a View to automatically add/remove classes:

```
  smartclasses:
    <className>:
      deps:[]
      test: <function>
```

And invoke the initializer:

```JavaScript
  Backbone.View.extend({
    ...
    initialize: function() {
      this.initComputed();
    },
    ...
  });
```

###Options

#### deps (required for model-bound views; optional for collection-bound views)
Type: `Array`

Specifies the fields (for models) or events (for collections) induce recomputation of smartclasses. 

It is strongly recommend that, for performance reasons, you specify this property for collection-bound views; in most cases, you probably only care about `['add', 'remove']` or `[change:<specific-field>]`.

#### test (optional)
Type: `function`

The method for determining whether or not class should be added to the view. If omitted and any item in `deps` is truthy, the class will be added to the view

### Example

The following JS and CSS show how to automatically show and hide a view based on its model's state.

```css
.hidden {
  display: none;
}
```

```JavaScript
  Backbone.View.extend({
    smartclasses: {
      hidden: {
        deps: [
          'firstName',
          'lastName',
        ]
      },
      test: function() {
        return !(this.has('firstName') && this.has('lastName'));
      }
    },

    initialize: function() {
      this.initComputed();
    }
  });
```

## TODO

- Add support for triggers outside of change events, e.g. elEvents, modelEvents, collectionEvents
- Add support for additional attributes (e.g. it may be desirable to alter the aria attributes of View)
- Add support for altering elements other than this.$el


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/ianwremmel/backbone.smartclasses/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

