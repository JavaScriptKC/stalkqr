event_store = {}

findEventsByUserId = (user_id) ->
  event_store[user_id] or []

Event = (id, name) ->      
  this.name = name
  this.id = id
  this.codes = []
  return

Event.prototype.addCodes = (new_codes, callback) ->
  this.codes = this.codes.concat new_codes
  callback null, this

createEvent = (user_id, event_name, callback) ->
  events = findEventsByUserId user_id
  event = new Event events.length, event_name
  events.push event
  event_store[user_id] = events
  callback null, event

findFirst = (user_id, filter) ->
  result = findEventsByUserId(user_id).filter filter
  result[0] || null

findByName = (user_id, event_name, callback) ->
  callback null, findFirst user_id, (e) ->
    e.name == event_name

list = (user_id, callback) ->
  callback null, findEventsByUserId user_id

module.exports = 
  list: list
  findByName: findByName
  create: createEvent