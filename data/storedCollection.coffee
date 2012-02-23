InMemoryDataAdapter = require './adapters/inMemory'

class StoredCollection
  constructor: () ->
    @_adapter = new InMemoryDataAdapter()

  find: (collection, criteria, callback) ->
    @_adapter.find(collection, criteria, callback)

module.exports = StoredCollection