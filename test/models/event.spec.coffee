should = require 'should'
Event = require '../../models/event.coffee'

describe('Events (models/event)', ->
  describe('creating an event', ->
    beforeEach ->
      @event = new Event()

    it 'should have no name', ->
      should.not.exist(@event.attributes.name)

    it 'should have zero codes', ->
      @event.attributes.codes.length.should.equal(0)
  )
)