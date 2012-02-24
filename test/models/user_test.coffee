vows = require 'vows'
should = require 'should'
User = require '../../models/user'
    
vows.describe('User (models/user)').addBatch(
  'when creating a user model': {
    topic: () -> new User()

    'it should have default values': (user) ->
      should.strictEqual(user.attributes.name, undefined)
      should.strictEqual(user.attributes.userSince, undefined)
      user.attributes.slugs.should.have.length(0)
      user.attributes.handles.should.have.length(0)
      user.attributes.credentials.should.have.length(0)
  }

  'when creating a user model with attributes': {
    topic: () -> new User(expectedAttributes)
    
    'it should set the correct name': (user) ->
      user.attributes.name.should.equal(expectedAttributes.name)
    
    'it should set the correct user since date': (user) ->
      user.attributes.userSince.should.equal(expectedAttributes.userSince)
    
    'it should set the correct slugs': (user) ->
      user.attributes.slugs.should.eql(expectedAttributes.slugs)
    
    'it should set the correct handles': (user) ->
      user.attributes.handles.should.eql(expectedAttributes.handles)
    
    'it should set the correct credentials': (user) ->
      user.attributes.credentials.should.eql(expectedAttributes.credentials)
    
    'it should set the correct id': (user) ->    
      user.attributes._id.should.equal(expectedAttributes._id)
  }

  'when calling save() on a user': {
    topic: () -> 
      getUser().save(@callback)

    'it should call save on the base model': (err, attributes) ->
      callsToSave.should.have.length(1)
      callsToSave[0].should.have.length(2)

    'it should save to the \'users\' collection': (err, attributes) ->
      callsToSave[0][0].should.equal('users')
  }
).export(module)

expectedAttributes =
  name: 'Abraham Lincoln'               
  userSince: new Date()
  slugs: ['abe', 'penniesrock']
  handles: [{type: 'twitter', handle: 'abelincoln'}]
  credentials: [{provider: 'twitter', id: 1234 }]
  _id: 1234

callsToSave = []

getUser = () ->
  user = new User()
  user._adapter = 
    save: (collection, callback) ->
      callsToSave.push([collection, callback])
      callback(null, @attributes)
  return user