class StoredObject
  _dataStore: undefined

  save: (collectionName, attributes, callback) ->
    _dataStore.save(collectionName, attributes, callback)

module.exports = StoredObject