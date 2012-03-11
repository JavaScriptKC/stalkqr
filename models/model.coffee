clone = require 'clone'
StoredObject = require '../data/storedObject'

class Model extends StoredObject
  constructor: (attributes) ->
    super
    @attributes = clone(attributes) || {}

  save: (collection, callback) ->
    super(collection, @toJSON(), (err, attributes) =>
      @attributes = attributes if not err?
      callback(err, attributes) if callback?
    )

  toJSON: () ->
    clone(@attributes)

module.exports = Model