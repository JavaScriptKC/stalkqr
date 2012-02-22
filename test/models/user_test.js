var User, assert, expectedAttributes, vows;

vows = require('vows');

assert = require('assert');

User = require('../../models/user');

expectedAttributes = {
  name: 'Abraham Lincoln',
  userSince: Date.parse('April 14, 1865'),
  slugs: ['abe', 'penniesrock'],
  handles: [
    {
      type: 'twitter',
      handle: 'abelincoln'
    }
  ],
  credentials: [
    {
      provider: 'twitter',
      id: 1234
    }
  ],
  _id: 1234
};

vows.describe('User (models/user)').addBatch({
  'When creating a user model': {
    topic: function() {
      return new User();
    },
    'it should have default values': function(user) {
      assert.isUndefined(user.attributes.name);
      assert.isUndefined(user.attributes.userSince);
      assert.isEmpty(user.attributes.slugs);
      assert.isEmpty(user.attributes.handles);
      assert.isEmpty(user.attributes.credentials);
      return assert.isUndefined(user.attributes._id);
    },
    'and toJSON is called on the new user with a name.': {
      topic: function(user) {
        user.attributes.name = expectedAttributes.name;
        return user.toJSON();
      },
      'it should have the users name populated.': function(jsonResult) {
        return assert.equal(jsonResult.name, expectedAttributes.name);
      },
      'it should not have any slugs': function(jsonResult) {
        return assert.isEmpty(jsonResult.slugs);
      },
      'it should not have any handles': function(jsonResult) {
        return assert.isEmpty(jsonResult.handles);
      },
      'it should not have any credentials': function(jsonResult) {
        return assert.isEmpty(jsonResult.credentials);
      },
      'it should not have the user since date set': function(jsonResult) {
        return assert.isUndefined(jsonResult.userSince);
      },
      'it should not set an id': function(jsonResult) {
        return assert.isUndefined(jsonResult._id);
      }
    },
    'and a brand new credential is added': {
      topic: function() {
        var user;
        user = new User();
        user.setCredential('twitter', 1865);
        return user;
      },
      'it should add the credential': function(user) {
        assert.equal(user.attributes.credentials.length, 1);
        assert.equal(user.attributes.credentials[0].provider, 'twitter');
        return assert.equal(user.attributes.credentials[0].id, 1865);
      },
      'and the same credential is added again with a different id': {
        topic: function(user) {
          user.setCredential('twitter', 1234);
          return user;
        },
        'it should override the existing value': function(user) {
          assert.equal(user.attributes.credentials.length, 1);
          assert.equal(user.attributes.credentials[0].provider, 'twitter');
          return assert.equal(user.attributes.credentials[0].id, 1234);
        }
      },
      'and the same credential is added with different casing': {
        topic: function(user) {
          user.setCredential('Twitter', 1234);
          return user;
        },
        'it should override the existing value': function(user) {
          assert.equal(user.attributes.credentials.length, 1);
          assert.equal(user.attributes.credentials[0].provider, 'twitter');
          return assert.equal(user.attributes.credentials[0].id, 1234);
        }
      },
      'and the same credential is added with different casing and white space': {
        topic: function(user) {
          user.setCredential(' Twitter ', 1234);
          return user;
        },
        'it should override the existing value': function(user) {
          assert.equal(user.attributes.credentials.length, 1);
          assert.equal(user.attributes.credentials[0].provider, 'twitter');
          return assert.equal(user.attributes.credentials[0].id, 1234);
        }
      },
      'and a completely different credential is added': {
        topic: function(user) {
          user.setCredential('github', 100);
          return user;
        },
        'it should be appended to the credentials': function(user) {
          assert.equal(user.attributes.credentials.length, 2);
          return assert.equal(user.attributes.credentials[1].provider, 'github');
        }
      }
    }
  },
  'Creating a user model from attributes': {
    topic: function() {
      var user;
      return user = new User(expectedAttributes);
    },
    'it should set the correct name': function(user) {
      return assert.equal(user.attributes.name, expectedAttributes.name);
    },
    'it should set the correct user since date': function(user) {
      return assert.equal(user.attributes.userSince, expectedAttributes.userSince);
    },
    'it should set the correct slugs': function(user) {
      return assert.deepEqual(user.attributes.slugs, expectedAttributes.slugs);
    },
    'it should set the correct handles': function(user) {
      return assert.deepEqual(user.attributes.handles, expectedAttributes.handles);
    },
    'it should set the correct credentials': function(user) {
      return assert.deepEqual(user.attributes.credentials, expectedAttributes.credentials);
    },
    'it should set the correct id': function(user) {
      return assert.equal(user.attributes._id, expectedAttributes._id);
    },
    'and toJSON() is called': {
      topic: function(user) {
        return user.toJSON();
      },
      'it should set the correct name': function(jsonResult) {
        return assert.equal(jsonResult.name, expectedAttributes.name);
      },
      'it should set the correct slugs': function(jsonResult) {
        return assert.deepEqual(jsonResult.slugs, expectedAttributes.slugs);
      },
      'it should set the correct handles': function(jsonResult) {
        return assert.deepEqual(jsonResult.handles, expectedAttributes.handles);
      },
      'it should set the correct credentials': function(jsonResult) {
        return assert.deepEqual(jsonResult.credentials, expectedAttributes.credentials);
      },
      'it should set the correct id': function(jsonResult) {
        return assert.equal(jsonResult._id, expectedAttributes._id);
      }
    }
  }
})["export"](module);
