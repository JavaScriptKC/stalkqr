vows = require 'vows'
assert = require 'assert'
User = require '../../models/user'

expectedAttributes =
  name: 'Abraham Lincoln'               
  userSince: new Date()
  slugs: ['abe', 'penniesrock']
  handles: [{type: 'twitter', handle: 'abelincoln'}]
  credentials: [{provider: 'twitter', id: 1234 }]
  _id: 1234
    
vows.describe('User (models/user)').addBatch(
  'when creating a user model': {
    topic: () -> new User()

    'it should have default values': (user) ->
      assert.isUndefined user.attributes.name
      assert.isUndefined user.attributes.userSince
      assert.isArray user.attributes.slugs
      assert.isArray user.attributes.handles
      assert.isArray user.attributes.credentials
  }

  'when creating a user model with attributes': {
    topic: () -> new User(expectedAttributes)
    
    'it should set the correct name': (user) ->
      assert.equal user.attributes.name, expectedAttributes.name
    
    'it should set the correct user since date': (user) ->
      assert.equal user.attributes.userSince, expectedAttributes.userSince 
    
    'it should set the correct slugs': (user) ->
      assert.deepEqual user.attributes.slugs, expectedAttributes.slugs
    
    'it should set the correct handles': (user) ->
      assert.deepEqual user.attributes.handles, expectedAttributes.handles 
    
    'it should set the correct credentials': (user) ->
      assert.deepEqual user.attributes.credentials, expectedAttributes.credentials
    
    'it should set the correct id': (user) ->    
      assert.equal user.attributes._id, expectedAttributes._id
  }
).export module
