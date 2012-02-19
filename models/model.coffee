StoredObject = require './storedObject'

class Model extends StoredObject
  save: (modelName, callback) =>
    super @modelName, @toJSON(), callback

module.exports = Model