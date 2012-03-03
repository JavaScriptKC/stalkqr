should = require 'should'
Tag = require '../../models/tag'
User = require '../../models/user'

expectedAttributes =
  _id: 1234
  generatedOn: new Date()
  user: new User()
  event: { 'event': 'this is it!' }
  code: '23aij0fj093j0j329jkasdjiowej'

callsToSave = []

getTag = () ->
  tag = new Tag()
  tag._adapter = 
    save: (collection, attributes, callback) ->
      callsToSave.push([collection, callback])
      callback(null, @attributes)
  return tag

describe 'When creating a new tag', ->

  beforeEach ->
    @tag = new Tag()

  it 'should have default attributes', ->
    should.strictEqual(@tag.attributes._id, undefined)
    should.strictEqual(@tag.attributes.user, undefined)
    should.strictEqual(@tag.attributes.event, undefined)
    should.exist(@tag.attributes.generatedOn)
    should.exist(@tag.attributes.code)

describe 'When creating a tag with attributes', -> 
  
  beforeEach ->
    @tag = new Tag(expectedAttributes)
    
  it 'should set the correct id', ->
    @tag.attributes._id.should.equal(expectedAttributes._id)
  
  it 'should set the correct generatedOn date', ->
    @tag.attributes.generatedOn.should.eql(expectedAttributes.generatedOn)
  
  it 'should set the correct code', ->
    @tag.attributes.code.should.equal(expectedAttributes.code)
  
  it 'should set the correct event', ->
    @tag.attributes.event.should.eql(expectedAttributes.event)

  describe 'when calling save() on a tag', ->
    getTag().save ->

    it 'should call save on the base model', ->
      callsToSave.should.have.length(1)
      callsToSave[0].should.have.length(2)

    it 'should save to the \'tags\' collection', ->
      callsToSave[0][0].should.equal('tags')
