StoredObject = require '../data/storedObject'

class Model extends StoredObject
  constructor: (attributes) ->
    @attributes = attributes || {}

  save: (collection, callback) ->
    super(collection, @toJSON(), (err, attributes) =>
      @attributes = attributes if not err?
      callback(err, attributes) if callback?
    )

  toJSON: () ->
    JSON.parse(JSON.stringify(@attributes))

module.exports = Model