vows = require 'vows'
should = require 'should'
StoredObject = require '../../data/storedObject'
Model = require '../../models/model'

callsToSave = []

getModel = (attribs) ->
  model = new Model(attribs)
  model._adapter = 
    save: (collection, attributes, callback) ->
      callsToSave.push([collection, attributes, callback])
      callback(null, attributes)
  return model

describe 'When a model is being created without attributes', ->
  model = null
  
  beforeEach ->
    model = getModel()

  it 'should not have any attributes', ->
    model.attributes.should.eql({})

  describe 'When toJSON() is called', ->
    beforeEach ->
      jsonObject = model.toJSON()

    it 'should return an empty object', ->
      jsonObject.should.eql({})

describe 'When a model is created with attributes', ->
  model = null

  beforeEach ->
    model = new Model(two: false)

  it 'should have the correct attributes', ->
    model.attributes.should.eql two: false 

  describe 'When toJSON() is called', ->
    modelJson = null
    
    beforeEach ->
      modelJson = model.toJSON()

    it 'should return the attributes object', ->
      modelJson.should.eql({ 'two': false })

describe 'when save() is called', ->

  model = getModel({'one': true})

  model.save 'testCollection', ->

  it 'should call save() on the base object', ->
    callsToSave.should.have.length(1)
    
  it 'should pass model.attributes to the save()', ->
    callsToSave[0].should.have.length(3)
    callsToSave[0][1].should.eql({ 'one': true })

  it 'should pass collection and callback to base', ->
    callsToSave[0].should.have.length(3)
    callsToSave[0][0].should.equal('testCollection')
    callsToSave[0][2].should.not.be.null