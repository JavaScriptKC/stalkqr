vows = require 'vows'
should = require 'should'
StoredObject = require '../../data/storedObject'
Model = require '../../models/model'

callCount = 0
args = []

getTopic = () ->
  topic = new Model()
  topic._adapter = 
    save: (collection, attributes, callback) ->
      callCount++;
      args.push([collection, attributes, callback])
      callback(null, attributes)
  return topic

vows.describe('Base model (models/model)').addBatch(
  '': {
    topic: () -> getTopic()

    'when toJSON() is called': {
      topic: (instance) -> instance.toJSON()

      'it should return an empty object': (jsonObject) ->
        jsonObject.should.eql({})
    }

    'when save() is called': {
      topic: (instance) -> 
        instance.save('testCollection', @callback)
      
      'it should call save() on the base stored object': (err, attributes) ->
        callCount.should.equal(1)
        args.should.have.length(1)
      
      'it should pass all arguments to the base object': (err, attributes) ->
        args[0].should.have.length(3)
        args[0][0].should.equal('testCollection')
        args[0][1].should.eql({})
        args[0][2].should.equal(@callback)
    }
  }
).export(module)
