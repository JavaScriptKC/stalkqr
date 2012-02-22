clone = require 'clone'
StoredObject = require '../data/storedObject'

class Model extends StoredObject
  constructor: (attributes) ->
    @attributes = clone(attributes) || {}

  save: (collection, callback) ->
    super @collection, @toJSON(), callback

  toJSON: () ->
    clone(@attributes)

module.exports = Model