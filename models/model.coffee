StoredObject = require '../data/storedObject'

class Model extends StoredObject
  constructor: (attributes) ->
    @attributes = attributes || {}

  save: (collection, callback) ->
    super(collection, @toJSON(), callback)

  toJSON: () ->
    JSON.parse(JSON.stringify(@attributes))

module.exports = Model