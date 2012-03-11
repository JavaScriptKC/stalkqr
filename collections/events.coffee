StoredCollection = require '../data/storedCollection'

class Events extends StoredCollection
  constructor: () -> super

  find: (criteria, callback) ->
    super(Events._collectionName, criteria, callback)

  findByUser: (user, callback) ->
    userId = if user.attributes?._id? then user.attributes._id else user
    @find({ user: userId }, callback)

Events._collectionName = 'events'
module.exports = Events