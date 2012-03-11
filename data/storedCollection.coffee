InMemoryDataAdapter = require './adapters/inMemory'

class StoredCollection
  constructor: () ->
    @_adapter = new InMemoryDataAdapter()

  find: () ->
    if arguments.length is 2
      criteria = {}
      [collection, callback] = arguments

    if arguments.length is 3
      [collection, criteria, callback] = arguments
    @_adapter.find(collection, criteria, callback)

module.exports = StoredCollection