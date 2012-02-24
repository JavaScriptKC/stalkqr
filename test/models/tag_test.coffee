vows = require 'vows'
should = require 'should'
Tag = require '../../models/tag'
User = require '../../models/user'
    
vows.describe('Tag (models/tag)').addBatch(
  'when creating a tag': {
    topic: () -> new Tag()

    'it should have default attributes': (tag) ->
      should.strictEqual(tag.attributes._id, undefined)
      should.strictEqual(tag.attributes.user, undefined)
      should.strictEqual(tag.attributes.event, undefined)
      should.exist(tag.attributes.generatedOn)
      should.exist(tag.attributes.code)
  }

  'when creating a tag with attributes': {
    topic: () -> new Tag(expectedAttributes)
    
    'it should set the correct id': (tag) ->
      tag.attributes._id.should.equal(expectedAttributes._id)
    
    'it should set the correct generatedOn date': (tag) ->
      tag.attributes.generatedOn.should.equal(expectedAttributes.generatedOn)
    
    'it should set the correct code': (tag) ->
      tag.attributes.code.should.equal(expectedAttributes.code)
    
    'it should set the correct user': (tag) ->
      tag.attributes.user.should.equal(expectedAttributes.user)
    
    'it should set the correct event': (tag) ->
      tag.attributes.event.should.equal(expectedAttributes.event)
  }

  'when calling save() on a tag': {
    topic: () -> 
      getTag().save(@callback)

    'it should call save on the base model': (err, attributes) ->
      callsToSave.should.have.length(1)
      callsToSave[0].should.have.length(2)

    'it should save to the \'tags\' collection': (err, attributes) ->
      callsToSave[0][0].should.equal('tags')
  }
).export(module)

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
    save: (collection, callback) ->
      callsToSave.push([collection, callback])
      callback(null, @attributes)
  return tag