class InMemoryDataAdapter
  constructor: () ->
    @items = {}

  save: (collection, attributes, callback) =>
    @items[collection] or= []
    if attributes._id? then @update(collection, attributes, callback)
    else @insert(collection, attributes, callback)

  find: (collection, criteria, callback) =>
    results = []

    for item in @items[collection] || []
      allTrue = true

      for name, value of criteria
        if item[name] isnt value
          allTrue = false
      
      if allTrue
        results.push(item)

    callback(null, results)

  insert: (collection, attributes, callback) ->
    attributes = copy(attributes)
    attributes._id = @items[collection].length
    @items[collection].push(attributes)
    callback(null, attributes)

  update: (collection, attributes, callback) ->
    attributes = copy(attributes)
    id = attributes._id
    @items[collection][id] = attributes
    callback(null, attributes)

copy = (object) ->
  JSON.parse(JSON.stringify(object))

module.exports = InMemoryDataAdapter