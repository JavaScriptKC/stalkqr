vows = require 'vows'
assert = require 'assert'
events = require '../models/event.coffee'

vows.describe('Events').addBatch(
  'when a user creates an event':
    topic: () ->
      events.create 'abc123', 'eventName', this.callback
    'an event object with the same name should be returned': (err, event) ->
      assert.equal 'eventName', event.name
    'the returned event should have zero codes': (err, event) ->
      assert.equal 0, event.codes.length
    'and codes are added to the event':
      topic: (event) ->
        event.addCodes ['123', '456'], this.callback
      'the event should now have the codes': (err, event) ->
        assert.equal 2, event.codes.length
        assert.equal '123', event.codes[0]
        assert.equal '456', event.codes[1]
    'and list is called with the same user':
      topic: () ->
        events.list 'abc123', this.callback
      'a list containing the created event should be returned': (err, list) ->
        assert.equal 1, list.length
        assert.equal 'eventName', list[0].name
    'and findByName is called with the same user and eventName': () ->
      topic: () -> 
        events.findByName 'abc123', 'eventName', this.callback
      'the created event should be returned': (err, event) ->
        assert.equal 'eventName', event.name

).export module