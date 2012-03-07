require 'should'
events = require '../../models/event.coffee'

describe('Events (models/event)', ->
  describe('creating an event', ->
    beforeEach (done) ->
      events.create('abc123', 'eventName', (err, event) =>
        @event = event
        @error = err
        done()
      )

    it 'should have the correct name', ->
      @event.name.should.equal('eventName')

    it 'should have zero codes', ->
      @event.codes.length.should.equal(0)

    describe('and adding codes to the event', ->
      beforeEach ->
        @event.addCodes(['123', '456'], ->)

      it 'should have the codes', ->
        @event.codes.length.should.equal(2)
        @event.codes[0].should.equal('123')
        @event.codes[1].should.equal('456')
    )

    describe('and calling findByName with the same user and eventName', ->
      beforeEach (done) ->
        events.findByName 'abc123', 'eventName', (error, event) =>
          @event = event
          @error = error
          done()

      it 'should return the expected event', ->
        @event.name.should.equal('eventName')
    )
  )
)
