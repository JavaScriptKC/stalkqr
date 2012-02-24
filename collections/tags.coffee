StoredCollection = require '../data/storedCollection'

class Tags extends StoredCollection
  constructor: () -> super

  find: (criteria, callback) ->
    super(Tags._collectionName, criteria, callback)

Tags._collectionName = 'tags'
module.exports = Tags