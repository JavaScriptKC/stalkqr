InMemoryDataAdapter = require './adapters/inMemory'

class StoredObject
  _adapter: new InMemoryDataAdapter()

  save: (collection, attributes, callback) ->
    _adapter.save(collection, attributes, callback)

module.exports = StoredObject