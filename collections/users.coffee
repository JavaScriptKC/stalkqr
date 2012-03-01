StoredCollection = require '../data/storedCollection'

class Users extends StoredCollection
  constructor: () -> super

  find: () ->
    if arguments.length is 1
      criteria = {}
      [callback] = arguments

    if arguments.length is 2
      [criteria, callback] = arguments
      
    super(Users._collectionName, criteria, callback)

  all: (callback) -> 
    @find(callback)

Users._collectionName = 'users'
module.exports = Users