_ = require 'lodash'
jQuery = require 'jquery'
Backbone = require 'backbone'

# These seems like the wrong way to point Backbone at jQuery, but it seems to
# work.
Backbone.$ = jQuery

sinon = require 'sinon'
chai = require 'chai'
assert = chai.assert

smartclasses = require '../lib/backbone.smartclasses.js'

Cocktail = require 'cocktail';
Cocktail.patch(Backbone);

describe 'Backbone.Smartclasses', ->
  it 'is a mixin', ->
    View = Backbone.View.extend
      mixins: [smartclasses]

    assert.isDefined View::initialize
    assert.isFunction View::initialize

    view = new View
    assert.isDefined view.initialize
    assert.isFunction view.initialize

  it 'can only be applied to views', ->
    assert.throws ->
      Collection = Backbone.Collection.extend
        mixins: [smartclasses]
      collection = new Collection

    assert.throws ->
      Router = Backbone.Router.extend
        mixins: [smartclasses]
      router = new Router

    assert.throws ->
      Model = Backbone.Model.extend
        mixins: [smartclasses]
      model = new Model

    assert.doesNotThrow ->
      View = Backbone.View.extend
        mixins: [smartclasses]
      view = new View

  it 'is not required', ->
    assert.doesNotThrow ->
      View = Backbone.View.extend
        mixins: [smartclasses]
      view = new View

  describe '#smartclasses', ->
    it 'can be set via extend', ->
      View =Backbone.View.extend
        mixins: [smartclasses]

        smartclasses:
          active:
            deps: ['active']

      view = new View

      assert.isDefined view.smartclasses
      assert.isDefined view.smartclasses.active

    it 'can be set via options', ->
      View = Backbone.View.extend
        mixins: [smartclasses]

      view = new View
        smartclasses:
          active:
            deps: ['active']

      assert.isDefined view.smartclasses
      assert.isDefined view.smartclasses.active

      it 'can be set via options and extend', ->
        View = Backbone.View.extend
          mixins: [smartclasses]

          smartclasses:
            active:
              deps: ['active']

        view = new View
          smartclasses:
            'can-drive':
              deps: ['age']

        assert.isDefined view.smartclasses
        assert.isDefined view.smartclasses.active
        assert.isDefined view.smartclasses['can-drive']

    it 'can be overridden via options', ->
      View = Backbone.View.extend
        mixins: [smartclasses]

        smartclasses:
          active:
            deps: ['active']

      view = new View
        smartclasses:
          active:
            deps: ['inactive']

      assert.equal view.smartclasses.active.deps.length, 1
      assert.equal view.smartclasses.active.deps[0], 'inactive'

    describe '#deps', ->
      it 'is required', ->
        assert.throws ->
          View = Backbone.View.extend
            mixins: [smartclasses]
            smartclasses:
              active: {}

          view = new View

        assert.throws ->
          View = Backbone.View.extend
            mixins: [smartclasses]
            smartclasses:
              active:
                deps: []
          view = new View

      it 'specified which fields may induce a change', ->
        test = sinon.spy()
        model = new Backbone.Model
          active: false
          age: 27

        View = Backbone.View.extend
          mixins: [smartclasses]

          smartclasses:
            active:
              deps: [
                'active'
              ]

          test: test

        view = new View model: model

        model.set age: 20
        assert.equal test.callCount, 0

        model.set active: true
        assert.isTrue test.calledOnce

        model.set age: 12
        assert.isTrue test.calledOnce


    describe '#test', ->
      it 'is not required', ->
        assert.doesNotThrow ->
          View = Backbone.View.extend
            mixins: [smartclasses]

            smartclasses:
              active:
                deps: [
                  'active'
                ]
          view = new View

    describe '#target', ->
      it 'is not required'
      it 'specifies which element to alter'

  describe 'initialize', ->
    it 'initalizes each smartclass definition'
