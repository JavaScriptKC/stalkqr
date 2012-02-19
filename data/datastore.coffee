class InMemoryDataStore
  constructor: () ->
    @store = {}

  save: (modelName, attributes, callback) =>
    store = @store[modelName] or= []

    if modelAlreadyStored(attributes)
      update(store, attributes, callback)
    else
      insert(store, attributes, callback)

  insert: (store, attributes, callback) ->
    id = store.length
    attributes._id = id
    store.push attributes
    callback(null, attributes)

  update: (store, attributes, callback) ->
    id = attributes._id
    store[id] = attributes
    callback(null, attributes)

modelAlreadyStored = (attributes) ->
  attributes._id?