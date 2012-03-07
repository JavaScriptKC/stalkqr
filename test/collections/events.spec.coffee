should = require 'should'
User = require '../../models/user'
Events = require '../../collections/events'

callsToFind = {}

getEvents = (key) ->
  callsToFind[key] = []
  events = new Events()
  events._adapter =
    find: (collection, criteria, callback) ->
      callsToFind[key].push([collection, criteria, callback])
      callback(null, [])
  return events

describe('Events (collections/events)', ->
  describe('calling find() with criteria and a callback', ->
    getEvents('test1').find({ 'one': true }, ->)

    it 'should call find() in \'events\' collection on base', ->
      callsToFind.test1.should.have.length(1)
      callsToFind.test1[0].should.have.length(3)
      callsToFind.test1[0][0].should.equal('events')

    it 'should call find() with criteria on base', ->
      callsToFind.test1[0][1].should.eql({ 'one': true })
  )

  describe('calling findByUser() with a user object', ->
    beforeEach ->
      user = new User({ _id: 33 });
      getEvents('test2').findByUser(user, ->)

    it 'should call find() in \'events\' collection on base', ->
      callsToFind.test2.should.have.length(1)
      callsToFind.test2[0].should.have.length(3)
      callsToFind.test2[0][0].should.equal('events')

    it 'should call find() with user id on base', ->
      callsToFind.test2[0][1].should.eql({ 'user': 33 })
  )

  describe('calling findByUser() with a user id', ->
    beforeEach ->
      getEvents('test2').findByUser(37, ->)

    it 'should call find() in \'events\' collection on base', ->
      callsToFind.test2.should.have.length(1)
      callsToFind.test2[0].should.have.length(3)
      callsToFind.test2[0][0].should.equal('events')

    it 'should call find() with user id on base', ->
      callsToFind.test2[0][1].should.eql({ 'user': 37 })
  )
)