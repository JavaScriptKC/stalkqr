Model = require './model'

class User extends Model
  constructor: (attributes = {}) ->
    super 
    @attributes.name or= undefined
    @attributes.userSince or= undefined
    @attributes.slugs or= []
    @attributes.handles or= []
    @attributes.credentials or= []

  setCredential: (provider, id, callback) =>
    @attributes.credentials.push
      provider: provider,
      id: id

    @save('user', callback)
    
module.exports = User