require 'should'
events = require '../models/event.coffee'

describe 'when a user creates an event', ->

  beforeEach (done) ->
    events.create 'abc123', 'eventName', (err, event) =>
      @event = event
      @error = err
      done()

  it 'should return an object with the same name', ->
    @event.name.should.equal 'eventName'

  it 'the returned event should have zero codes', ->
    @event.codes.length.should.equal 0
  
  describe 'and codes are added to the event', ->
    
    beforeEach ->
      @event.addCodes ['123', '456'], ->
  
    it 'the event should now have the codes', ->
      @event.codes.length.should.equal 2
      @event.codes[0].should.equal '123'
      @event.codes[1].should.equal '456'
  
  describe 'and findByName is called with the same user and eventName', ->
    
    beforeEach (done) ->
      events.findByName 'abc123', 'eventName', (error, event) =>
        @event = event
        @error = error
        done()
    
    it 'the created event should be returned', ->
      @event.name.should.equal 'eventName'
