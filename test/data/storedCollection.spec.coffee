should = require 'should'
StoredCollection = require '../../data/storedCollection'

callsToFind = []

getStoredCollection = () ->
  storedCollection = new StoredCollection()
  storedCollection._adapter = 
    find: (collection, criteria, callback) ->
      callsToFind.push([collection, criteria, callback])
      callback(null, criteria)
  return storedCollection

describe 'When find() is called on Base store collection(data/storedCollection)', ->
  callback = ->
    
  getStoredCollection().find 'testCollection', {'one': true }, callback

  it 'should call the adapter\'s find() method', ->
    callsToFind.should.have.length(1)

  it 'should pass collection and attributes to the adapter', ->
    callsToFind[0].should.have.length(3)
    callsToFind[0][0].should.equal('testCollection')
    callsToFind[0][1].should.eql({ 'one': true })
    callsToFind[0][2].should.equal(callback)
