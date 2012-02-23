vows = require 'vows'
should = require 'should'
StoredCollection = require '../../data/storedCollection'

vows.describe('Base stored collection (data/storedCollection)').addBatch(
  '': {
    topic: () -> getStoredCollection()

    'when find() is called': {
      topic: (storedCollection) -> 
        storedCollection.find('testCollection', {
          'one': true
        }, @callback)
      
      'it should call the adapter\'s find() method': (err, attributes) ->
        callsToFind.should.have.length(1)
      
      'it should pass collection and attributes to the adapter': (err, attributes) ->
        callsToFind[0].should.have.length(3)
        callsToFind[0][0].should.equal('testCollection')
        callsToFind[0][1].should.eql({ 'one': true })
        callsToFind[0][2].should.equal(@callback)
    }
  }
).export(module)

callsToFind = []

getStoredCollection = () ->
  storedCollection = new StoredCollection()
  storedCollection._adapter = 
    find: (collection, criteria, callback) ->
      callsToFind.push([collection, criteria, callback])
      callback(null, criteria)
  return storedCollection