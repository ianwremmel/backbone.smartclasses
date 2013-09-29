# Backbone.Smartclasses [![Build Status](https://travis-ci.org/ianwremmel/backbone.smartclasses.png)](https://travis-ci.org/ianwremmel/backbone.smartclasses)

## Motivation

While Backbone.ModelBinding (and, I assume, most of the other legitimate model binding plugins) provides the ability to bind data values to view element attributes, it requires three data attributes and a custom function to alter class names in the general case. In fact, it actually requires more markup and more complex JavaScript than simply adding a model listener to the view class. More over, there's no way (in markup) to bind a model attribute to the View's $el at all.

This plugin was initially conceived for dealing with the case of adding and removing classnames from a View's $el, but can additionally be used to add and remove class names from any element within the View's $el.


## Usage

Add the computed hash to a View to automatically add/remove classes:

```
  smartclasses:
    <className>:
      deps:[]
      test: <function>
      target: <selector>
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

#### deps
Type: `Array`

Specifies the fields on which to listen for changes

#### test (optional)
Type: `function`

The method for determining whether or not class should be added to the view. If omitted and any item in `deps` is truthy, the class will be added to the view

#### target (optional)
Type: `string`

selector string to which to added the class. If omitted, the class will be added $el

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
        return this.has('firstName') && this.has('lastName');
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
