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
      model: new Backbone.Model

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
        model: new Backbone.Model
      view = new View

  it 'is not required', ->
    assert.doesNotThrow ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        model: new Backbone.Model
      view = new View

  describe '#smartclasses', ->
    it 'can be set via extend', ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        model: new Backbone.Model
        smartclasses:
          active:
            deps: ['active']

      view = new View

      assert.isDefined view.smartclasses
      assert.isDefined view.smartclasses.active

    it 'can be set via options', ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        model: new Backbone.Model
      view = new View
        smartclasses:
          active:
            deps: ['active']

      assert.isDefined view.smartclasses
      assert.isDefined view.smartclasses.active

    it 'can be set via options and extend', ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        model: new Backbone.Model
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
        model: new Backbone.Model
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
            model: new Backbone.Model
            smartclasses:
              active: {}

          view = new View

      it 'cannot be empty', ->
        assert.throws ->
          View = Backbone.View.extend
            mixins: [smartclasses]
            model: new Backbone.Model
            smartclasses:
              active:
                deps: []
          view = new View

      it 'specifies which fields may induce a change', ->
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

          testDepsForTruthiness: test

        # We test setClasses later; disable it for this test
        View::setClasses = ->

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
            model: new Backbone.Model
            smartclasses:
              active:
                deps: [
                  'active'
                ]
          view = new View

  describe 'initialize()', ->
    it 'requires the View to have a `model`', ->
      View = Backbone.View.extend
        mixins: [smartclasses]

      assert.throws ->
        view = new View

      assert.doesNotThrow ->
        model = new Backbone.Model
        view = new View model: model

  describe 'testDepsForTruthiness()', ->
    describe '_test()', ->
      it 'adjusts truthiness to include 0', ->
        assert.ok smartclasses._test 0
        assert.ok smartclasses._test true
        assert.ok smartclasses._test 'a string'
        assert.notOk smartclasses._test false
        assert.notOk smartclasses._test ''
        assert.notOk smartclasses._test null
        assert.notOk smartclasses._test undefined
        assert.notOk smartclasses._test NaN

    it 'is used if no test is specified', ->
      testDepsForTruthiness = sinon.spy()

      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]
        testDepsForTruthiness: testDepsForTruthiness

      # We test setClasses later; disable it for this test
      View::setClasses = ->

      model = new Backbone.Model
        active: true

      view = new View model: model

      model.set active: false
      assert.equal testDepsForTruthiness.callCount, 1

    it 'is invoked when a dep changes', ->
      testDepsForTruthiness = sinon.spy()

      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]
        testDepsForTruthiness: testDepsForTruthiness

      # We test setClasses later; disable it for this test
      View::setClasses = ->

      model = new Backbone.Model
        active: true

      view = new View model: model

      model.set active: false
      assert.equal testDepsForTruthiness.callCount, 1

      model.set active: false
      assert.equal testDepsForTruthiness.callCount, 1

      model.set active: true
      assert.equal testDepsForTruthiness.callCount, 2

    it 'returns true if all dependencies are truthy', ->
      View = Backbone.View.extend
        mixins: [smartclasses]

      model = new Backbone.Model
        active: true,
        age: 17,
        weight: 0;

      view = new View model: model

      assert.isTrue view.testDepsForTruthiness ['active', 'age', 'weight']

    it 'returns false if any dependencies are falsy', ->
      View = Backbone.View.extend
        mixins: [smartclasses]

      model = new Backbone.Model
        active: true,
        age: 17,
        weight: null;

      view = new View model: model

      assert.isFalse view.testDepsForTruthiness ['active', 'age', 'weight']

  describe 'setClasses()', ->
    it 'is invoked when the View is initialized', ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]

      View::setClasses = sinon.spy()
      view = new View model: new Backbone.Model
      assert.equal view.setClasses.callCount, 1

    it 'sets classes based on the initial values of their dependencies', ->
      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]
          canDrive:
            deps: [
              'canDrive'
            ]

      model = new Backbone.Model
        active: true
        canDrive: false

      view = new View model: model
      assert.isTrue view.$el.hasClass 'active'
      assert.isFalse view.$el.hasClass 'canDrive'

  describe 'setSmartclass()', ->
    it 'is invoked when a dependency changes', ->
      setSmartclass = sinon.spy()

      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]
        setSmartclass: setSmartclass

      # We test setClasses later; disable it for this test
      View::setClasses = ->

      model = new Backbone.Model
        active: true

      view = new View model: model

      model.set active: false
      assert.equal setSmartclass.callCount, 1

    it 'calls smartclasses#<classname>#test', ->
      test = sinon.spy()

      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]
            test: test

      # We test setClasses later; disable it for this test
      View::setClasses = ->

      model = new Backbone.Model
        active: false

      view = new View model: model

      model.set active: true
      assert.equal test.callCount, 1

    it 'adds or removes a class as appropriate', ->
      # Since most of the functions used in smartclasses are buit using `bind`
      # at runtime, they're difficult to test. For now, we'll need to settle for
      # testing the final outcome.
      View = Backbone.View.extend
        mixins: [smartclasses]
        smartclasses:
          active:
            deps: [
              'active'
            ]

      model = new Backbone.Model
        active: true

      view = new View model: model

      view.$el.addClass = sinon.spy()
      view.$el.removeClass = sinon.spy()

      model.set active: false
      assert.equal view.$el.removeClass.callCount, 1

      model.set active: true
      assert.equal view.$el.addClass.callCount, 1
