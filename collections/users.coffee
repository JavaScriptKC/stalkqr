StoredCollection = require '../data/storedCollection'

class Users extends StoredCollection
  constructor: () -> super

  find: () ->
    if arguments.length is 1
      criteria = {}
      [callback] = arguments

    if arguments.length is 2
      [criteria, callback] = arguments
      
    super('users', criteria, callback)

  all: (callback) -> @find(callback)

module.exports = Users