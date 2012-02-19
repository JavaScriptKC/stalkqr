Model = require './model'

class User extends Model
  constructor: (attributes = {}) ->
    @name = attributes.name || undefined
    @userSince = attributes.userSince || undefined
    @slugs = attributes.slugs || []
    @handles = attributes.handles || []
    @credentials = attributes.credentials || []

  setCredential: (provider, id, callback) =>
    @credentials.push
      provider: provider,
      id: id

    @save('user', callback)

  toJSON: () =>
    name: @name,
    slugs: @slugs,
    handles: @handles,
    credentials: @credentials

module.exports = User