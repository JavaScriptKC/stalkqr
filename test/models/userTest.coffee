vows = require 'vows'
assert = require 'assert'
User = require '../../models/user'

storedObject = require '../../models/storedObject'
InMemoryStore = require '../../data/dataStore'

storedObject::_dataStore = new InMemoryStore()

vows.describe('models/user').addBatch(
  "Creating a user":
    topic: () ->
      new User()

    ""
)