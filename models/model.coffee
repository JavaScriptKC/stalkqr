StoredObject = require '../data/storedObject'

class Model extends StoredObject
  save: (collection, callback) ->
    super @collection, @toJSON(), callback

  toJSON: () ->
    {}

module.exports = Model