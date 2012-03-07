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

describe('Model (models/model)', ->
  describe('creating a model without attributes', ->
    beforeEach ->
      @model = getModel()

    it 'should not have any attributes', ->
      @model.attributes.should.eql({})

    describe('and calling toJSON()', ->
      beforeEach ->
        @jsonObject = @model.toJSON()

      it 'should return an empty object', ->
        @jsonObject.should.eql({})
    )
  )

  describe('creating with attributes', ->
    beforeEach ->
      @model = new Model(two: false)

    it 'should have the correct attributes', ->
      @model.attributes.should.eql two: false

    describe('and calling toJSON()', ->
      beforeEach ->
        @modelJson = @model.toJSON()

      it 'should return the attributes object', ->
        @modelJson.should.eql({ 'two': false })
    )
  )

  describe('calling save()', ->
    beforeEach ->
      @model = getModel({'one': true})
      @model.save 'testCollection', ->

    it 'should call save() on the base object', ->
      callsToSave.should.have.length(1)

    it 'should pass model.attributes to the save()', ->
      callsToSave[0].should.have.length(3)
      callsToSave[0][1].should.eql({ 'one': true })

    it 'should pass collection and callback to base', ->
      callsToSave[0].should.have.length(3)
      callsToSave[0][0].should.equal('testCollection')
      callsToSave[0][2].should.not.be.null
  )
)