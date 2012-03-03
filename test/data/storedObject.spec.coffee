should = require 'should'
StoredObject = require '../../data/storedObject'

callsToSave = []

getStoredObject = () ->
  storedObject = new StoredObject()
  storedObject._adapter = 
    save: (collection, attributes, callback) ->
      callsToSave.push([collection, attributes, callback])
      callback(null, attributes)
  return storedObject

describe 'when save() is called on Base stored object (data/storedObject)', ->
  callback = ->

  getStoredObject().save('testCollection', {
    'one': true
  }, callback)
      
  it 'should call the adapter\'s save() method', ->
    callsToSave.should.have.length(1)
  
  it 'should pass collection and attributes to the adapter', ->
    callsToSave[0].should.have.length(3)
    callsToSave[0][0].should.equal('testCollection')
    callsToSave[0][1].should.eql({ 'one': true })
    callsToSave[0][2].should.equal(callback)
