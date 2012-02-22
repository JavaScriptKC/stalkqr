vows = require 'vows'
assert = require 'assert'
User = require '../../models/user'

expectedAttributes =
  name: 'Abraham Lincoln'               
  userSince: Date.parse('April 14, 1865')
  slugs: ['abe', 'penniesrock']
  handles: [{type: 'twitter', handle: 'abelincoln'}]
  credentials: [{provider: 'twitter', id: 1234 }]
  _id: 1234
    
vows.describe('User (models/user)').addBatch(
  'When creating a user model':
    topic: () ->
      new User()

    'it should have default values': (user) ->
      assert.isUndefined user.attributes.name
      assert.isUndefined user.attributes.userSince
      assert.isEmpty user.attributes.slugs
      assert.isEmpty user.attributes.handles
      assert.isEmpty user.attributes.credentials
      assert.isUndefined user.attributes._id
    
    'and toJSON is called on the new user with a name.':
      topic: (user) ->
        user.attributes.name = expectedAttributes.name
        user.toJSON()
      
      'it should have the users name populated.': (jsonResult) ->
        assert.equal jsonResult.name, expectedAttributes.name
      
      'it should not have any slugs': (jsonResult) ->
        assert.isEmpty jsonResult.slugs
      
      'it should not have any handles': (jsonResult) ->
        assert.isEmpty jsonResult.handles
      
      'it should not have any credentials': (jsonResult) ->
        assert.isEmpty jsonResult.credentials

      'it should not have the user since date set': (jsonResult)->
        assert.isUndefined jsonResult.userSince
         
      'it should not set an id': (jsonResult) ->
        assert.isUndefined jsonResult._id 

    'and a brand new credential is added':
      topic: () ->
        user = new User()
        user.setCredential 'twitter', 1865
        user
      
      'it should add the credential': (user) ->
        assert.equal user.attributes.credentials.length, 1
        assert.equal user.attributes.credentials[0].provider, 'twitter'
        assert.equal user.attributes.credentials[0].id, 1865
      
      'and the same credential is added again with a different id':
        topic: (user) ->
          user.setCredential 'twitter', 1234
          user
      
        'it should override the existing value': (user) ->
          assert.equal user.attributes.credentials.length, 1
          assert.equal user.attributes.credentials[0].provider, 'twitter'
          assert.equal user.attributes.credentials[0].id, 1234
      
      'and the same credential is added with different casing':
        topic: (user) ->
          user.setCredential 'Twitter', 1234
          user

        'it should override the existing value': (user) ->
          assert.equal user.attributes.credentials.length, 1
          assert.equal user.attributes.credentials[0].provider, 'twitter'
          assert.equal user.attributes.credentials[0].id, 1234
    
      'and the same credential is added with different casing and white space':
        topic: (user) ->
          user.setCredential ' Twitter ', 1234
          user

        'it should override the existing value': (user) ->
          assert.equal user.attributes.credentials.length, 1
          assert.equal user.attributes.credentials[0].provider, 'twitter'
          assert.equal user.attributes.credentials[0].id, 1234

      'and a completely different credential is added':
        topic: (user) ->
          user.setCredential 'github', 100
          user
      
        'it should be appended to the credentials': (user) ->
          assert.equal user.attributes.credentials.length, 2
          assert.equal user.attributes.credentials[1].provider, 'github'

  'Creating a user model from attributes':
    topic: () ->
      user = new User expectedAttributes   

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
    
    'and toJSON() is called':
      topic: (user) ->
        user.toJSON()

      'it should set the correct name': (jsonResult) ->
        assert.equal jsonResult.name, expectedAttributes.name
      
      'it should set the correct slugs': (jsonResult) ->
        assert.deepEqual jsonResult.slugs, expectedAttributes.slugs
      
      'it should set the correct handles': (jsonResult) ->
        assert.deepEqual jsonResult.handles, expectedAttributes.handles 
      
      'it should set the correct credentials': (jsonResult) ->
        assert.deepEqual jsonResult.credentials, expectedAttributes.credentials
      
      'it should set the correct id': (jsonResult) ->    
        assert.equal jsonResult._id, expectedAttributes._id    
          
).export module
