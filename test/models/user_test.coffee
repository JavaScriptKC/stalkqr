vows = require 'vows'
assert = require 'assert'
User = require '../../models/user'
storedObject = require '../../data/storedObject'

expectedAttributes =
  name: 'Abraham Lincoln'               
  userSince: new Date()
  slugs: ['abe', 'penniesrock']
  handles: [{type: 'twitter', handle: 'abelincoln'}]
  credentials: [{provider: 'twitter', id: 1234 }]
  _id: 1234
    
vows.describe('models/user').addBatch(
  "Creating a user":
    topic: () ->
      new User()
    "it should have default values": (user) ->
      assert.isUndefined user.name
      assert.isUndefined user.userSince
      assert.isArray user.slugs
      assert.isArray user.handles
      assert.isArray user.credentials
  "Creating a user with attributes":
    topic: () ->
      new User expectedAttributes   
    
    "it should set the correct name": (user) ->
      assert.equal user.name, expectedAttributes.name
    
    "it should set the correct user since date": (user) ->
      assert.equal user.userSince, expectedAttributes.userSince 
    
    "it should set the correct slugs": (user) ->
      assert.deepEqual user.slugs, expectedAttributes.slugs
    
    "it should set the correct handles": (user) ->
      assert.deepEqual user.handles, expectedAttributes.handles 
    
    "it should set the correct credentials": (user) ->
      assert.deepEqual user.credentials, expectedAttributes.credentials
    
    "it should set the correct id": (user) ->    
      assert.equal user._id, expectedAttributes._id

).export module
