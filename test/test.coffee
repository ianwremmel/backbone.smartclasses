_ = require 'underscore'
jQuery = require 'jquery'
Backbone = require 'backbone'
chai = require 'chai'

require '../lib/backbone.computed.js'

assert = chai.assert

describe 'View', ->
	describe '#initSmartclasses()', ->
		it 'exists', ->
			assert.isDefined Backbone.View::initSmartclasses
			assert.isFunction Backbone.View::initSmartclasses

	describe '#smartclasses', ->
		describe '#deps', ->
			it 'is required'
			it 'specifies which fields may induce a change'
				# ensure test is call with a sinon spy

		describe '#test', ->
			it 'is not required'

		describe '#target', ->
			it 'is not required'
			it 'specifies which element to alter'
