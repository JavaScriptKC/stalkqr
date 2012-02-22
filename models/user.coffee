Model = require './model'

defaults =
  slugs: []
  credentials: []
  handles: []

class User extends Model
  constructor: (attributes = defaults) ->
    super attributes
  
  setCredential: (provider, id) ->
    @attributes.credentials or= []
    
    existingAttributes = @attributes.credentials.filter (c) ->
      c.provider.toLowerCase().trim() == provider.toLowerCase().trim()

    if existingAttributes.length > 0
      existingAttributes[0].id = id
    else
      @attributes.credentials.push 
        provider: provider 
        id: id
      
module.exports = User