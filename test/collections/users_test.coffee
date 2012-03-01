vows = require 'vows'
should = require 'should'
Users = require '../../collections/users'

vows.describe('Users (collections/users)').addBatch(
  'when find() is called with just a callback': {
    topic: () -> getUsers('test1').find(@callback)

    'it should call find() in \'users\' collection on base': (err, items) ->
      callsToFind.test1.should.have.length(1)
      callsToFind.test1[0].should.have.length(3)
      callsToFind.test1[0][0].should.equal('users')

    'it should call find() with empty criteria on base': (err, items) ->
      callsToFind.test1[0][1].should.eql({})
  }

  'when find() is called with criteria and a callback': {
    topic: (users) -> getUsers('test2').find({ 'one': true }, @callback)

    'it should call find() in \'users\' collection on base': (err, items) ->
      callsToFind.test2.should.have.length(1)
      callsToFind.test2[0].should.have.length(3)
      callsToFind.test2[0][0].should.equal('users')

    'it should call find() with criteria on base': (err, items) ->
      callsToFind.test2[0][1].should.eql({ 'one': true })
  }

  'when all() is called': {
    topic: () -> getUsers('test3').all(@callback)

    'it should call find() in \'users\' collection on base': (err, items) ->
      callsToFind.test3.should.have.length(1)
      callsToFind.test3[0].should.have.length(3)
      callsToFind.test3[0][0].should.equal('users')

    'it should call find() with empty criteria on base': (err, items) ->
      callsToFind.test3[0][1].should.eql({})
  }

).export(module)

callsToFind = {}

getUsers = (key) ->
  callsToFind[key] = []
  users = new Users()
  users._adapter =
    find: (collection, criteria, callback) ->
      callsToFind[key].push([collection, criteria, callback])
      callback(null, [])
  return users