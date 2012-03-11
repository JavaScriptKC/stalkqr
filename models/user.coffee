Model = require './model'
Users = require '../collections/users'

defaults =
  slugs: []
  credentials: []
  handles: []

class User extends Model
  constructor: (attributes = defaults) ->
    super
    @attributes._id or= undefined
    @attributes.name or= undefined
    @attributes.userSince or= undefined
    @attributes.slugs or= []
    @attributes.handles or= []
    @attributes.credentials or= []

  setCredential: (provider, id) ->
    existingAttributes = @attributes.credentials.filter (c) ->
      c.provider.toLowerCase().trim() == provider.toLowerCase().trim()
    
    if existingAttributes.length > 0
      existingAttributes[0].id = id
    else
      @attributes.credentials.push 
        provider: provider 
        id: id
        
  save: (callback) -> 
    super(Users._collectionName, callback)
      
module.exports = User