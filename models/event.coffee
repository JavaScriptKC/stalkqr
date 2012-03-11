Model = require './model'
Events = require '../collections/events'

class Event extends Model
  constructor: (attributes = {}) ->
    super
    @attributes._id or= undefined
    @attributes.name or= undefined
    @attributes.codes or= []

  save: (callback) ->
    super(Events._collectionName, callback)

module.exports = Event