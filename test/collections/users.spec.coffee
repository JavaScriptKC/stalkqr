should = require 'should'
Users = require '../../collections/users'

callsToFind = {}

getUsers = (key) ->
  callsToFind[key] = []
  users = new Users()
  users._adapter =
    find: (collection, criteria, callback) ->
      callsToFind[key].push([collection, criteria, callback])
      callback(null, [])
  return users

describe 'When find() is called for Users with just a callback', ->
  getUsers('test1').find ->

  it 'should call find() in \'users\' collection on base', ->
    callsToFind.test1.should.have.length(1)
    callsToFind.test1[0].should.have.length(3)
    callsToFind.test1[0][0].should.equal('users')

  it 'should call find() with empty criteria on base', ->
      callsToFind.test1[0][1].should.eql({})

describe 'When find() is called with criteria and a callback', ->
  getUsers('test2').find { 'one': true }, ->

  it 'should call find() in \'users\' collection on base', ->
    callsToFind.test2.should.have.length(1)
    callsToFind.test2[0].should.have.length(3)
    callsToFind.test2[0][0].should.equal('users')

  it 'should call find() with criteria on base', ->
    callsToFind.test2[0][1].should.eql({ 'one': true })

describe 'When all() is called', ->
  getUsers('test3').all ->

  it 'should call find() in \'users\' collection on base', ->
    callsToFind.test3.should.have.length(1)
    callsToFind.test3[0].should.have.length(3)
    callsToFind.test3[0][0].should.equal('users')

  it 'should call find() with empty criteria on base', ->
    callsToFind.test3[0][1].should.eql({})
