StoredObject = require '../data/storedObject'

class Model extends StoredObject
  save: (modelName, callback) ->
    super @modelName, @toJSON(), callback

  toJSON: () ->
    {}

module.exports = Model