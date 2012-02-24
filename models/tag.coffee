Model = require './model'
Code = require './codes'
Tags = require '../collections/tags'

class Tag extends Model
  constructor: (attributes = {}) ->
    super 
    @attributes._id or= undefined
    @attributes.user or= undefined
    @attributes.event or= undefined
    @attributes.generatedOn or= new Date()
    @attributes.code or= Code.generate()

  save: (callback) -> 
    super(Tags._collectionName, callback)

module.exports = Tag