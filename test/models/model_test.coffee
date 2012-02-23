vows = require 'vows'
should = require 'should'
StoredObject = require '../../data/storedObject'
Model = require '../../models/model'

vows.describe('Base model (models/model)').addBatch(
  '': {
    topic: () -> getModel()

    'when toJSON() is called when the model has no attributes': {
      topic: (model) -> 
        model.toJSON()

      'it should return an empty object': (jsonObject) ->
        jsonObject.should.eql({})
    }

    'when toJSON() is called when the model has attributes': {
      topic: (model) -> 
        model.attributes = { 'two': false }
        model.toJSON()

      'it should return the attributes object': (jsonObject) ->
        jsonObject.should.eql({ 'two': false })
    }

    'when save() is called': {
      topic: (model) -> 
        model.attributes = { 'one': true }
        model.save('testCollection', @callback)
      
      'it should call save() on the base object': (err, attributes) ->
        callsToSave.should.have.length(1)
        
      'it should pass model.attributes to the save()': (err, attributes) ->
        callsToSave[0].should.have.length(3)
        callsToSave[0][1].should.eql({ 'one': true })

      'it should pass collection and callback to base': (err, attributes) ->
        callsToSave[0].should.have.length(3)
        callsToSave[0][0].should.equal('testCollection')
        callsToSave[0][2].should.not.be.null
    }
  }
).export(module)

callsToSave = []

getModel = () ->
  model = new Model()
  model._adapter = 
    save: (collection, attributes, callback) ->
      callsToSave.push([collection, attributes, callback])
      callback(null, attributes)
  return model

