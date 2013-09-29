_ = require 'underscore'
jQuery = require 'jquery'
Backbone = require 'backbone'

# These seems like the wrong way to point Backbone at jQuery, but it seems to
# work.
Backbone.$ = jQuery

sinon = require 'sinon'
chai = require 'chai'

smartclasses = require '../lib/backbone.smartclasses.js'

assert = chai.assert

describe 'View', ->
	describe '#initSmartclasses()', ->
		it 'exists', ->
			# this test basically confirms that require is working correctly and
			# loading the smartclasses module did, in fact, alter the global Backbone
			# instance.
			assert.isDefined Backbone.View::initSmartclasses
			assert.isFunction Backbone.View::initSmartclasses
			view = new Backbone.View
			assert.isDefined view.initSmartclasses
			assert.isFunction view.initSmartclasses


		it 'initializes each smart class definition', ->
			view = new Backbone.View.extend
				initialize: ->
					@initSmartclasses()
				smartclasses:
					active: {}
					age: {}
				_initSmartclass: sinon.spy()

			assert.isDefined view._initSmartclass
			assert.isFunction view._initSmartclass

			assert.equal view._initSmartclass.callCount, 2



	describe '#smartclasses', ->
		describe '#deps', ->
			it 'is required', ->
				assert.throws ->
					new Backbone.View
						initialize: ->
							@initSmartclasses()

						smartclasses:
							testClass: {}

			it 'cannot be empty', ->
				assert.throws ->
					new Backbone.View
						initialize: ->
							@initSmartclasses()

						smartclasses:
							testClass:
								deps: []

			it 'specifies which fields may induce a change', ->
				test = sinon.spy()

				model = new Backbone.Model
					active: false
					age: 27

				view = new Backbone.View.extend
					initialize: ->
						initSmartclasses()

					smartclasses:
						active:
							deps: [
								'active'
							]
						test: test

				model.set age: 20
				assert.equal test.callCount, 0

				model.set active: true
				assert.isTrue test.calledOnce

				mode.set age: 12
				assert.isTrue test.calledOnce

		describe '#test', ->
			it 'is not required'

		describe '#target', ->
			it 'is not required'
			it 'specifies which element to alter'
