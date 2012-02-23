vows = require 'vows'
should = require 'should'
StoredObject = require '../../data/storedObject'

vows.describe('Base stored object (data/storedObject)').addBatch(
  '': {
    topic: () -> getTopic()

    'when save() is called': {
      topic: (instance) -> 
        instance.save('testCollection', {
          'one': true
        }, @callback)
      
      'it should call the adapter\'s save() method': (err, attributes) ->
        callCount.should.equal(1)
      
      'it should pass collection and attributes to the adapter': (err, attributes) ->
        args.should.have.length(1)
        args[0].should.have.length(3)
        args[0][0].should.equal('testCollection')
        args[0][1].should.eql({ 'one': true })
        args[0][2].should.equal(@callback)
    }
  }
).export(module)

callCount = 0
args = []

getTopic = () ->
  topic = new StoredObject()
  topic._adapter = 
    save: (collection, attributes, callback) ->
      callCount++;
      args.push([collection, attributes, callback])
      callback(null, attributes)
  return topic