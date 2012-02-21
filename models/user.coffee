Model = require './model'

class User extends Model
  constructor: (attributes = {}) ->
    @name = attributes.name || undefined
    @userSince = attributes.userSince || undefined
    @slugs = attributes.slugs || []
    @handles = attributes.handles || []
    @credentials = attributes.credentials || []
    @_id = attributes._id

  setCredential: (provider, id, callback) =>
    @credentials.push
      provider: provider,
      id: id

    @save('user', callback)

  toJSON: () =>
    name: @name
    slugs: @slugs
    handles: @handles
    credentials: @credentials
    _id: @_id
    
module.exports = User