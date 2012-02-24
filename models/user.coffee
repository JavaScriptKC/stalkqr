Model = require './model'
Users = require '../collections/users'

class User extends Model
  constructor: (attributes = {}) ->
    super 
    @attributes._id or= undefined
    @attributes.name or= undefined
    @attributes.userSince or= undefined
    @attributes.slugs or= []
    @attributes.handles or= []
    @attributes.credentials or= []

  setCredential: (provider, id, callback) =>
    @attributes.credentials.push
      provider: provider,
      id: id

    @save(callback)
    
  save: (callback) -> 
    super(Users._collectionName, callback)

module.exports = User