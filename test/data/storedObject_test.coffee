vows = require 'vows'
should = require 'should'
StoredObject = require '../../data/storedObject'

callCount = 0
args = []

StoredObject::_adapter = 
  save: (collection, attributes, callback) ->
    callCount++;
    args.push([collection, attributes, callback])
    callback(null, attributes)

vows.describe('Base stored object (data/storedObject)').addBatch(
  '': {
    topic: () -> new StoredObject()

    'when save is called': {
      topic: (instance) -> 
        instance.save('testCollection', {
          'one': true
        }, @callback)
      
      'it should call the adapter\'s save method': (err, attributes) ->
        callCount.should.equal(1)
      
      'it should pass collection and attributes to the adapter': (err, attributes) ->
        args.should.have.length(1)
        args[0][0].should.equal('testCollection')
        args[0][1].should.eql({ 'one': true })
    }
  }
).export(module)