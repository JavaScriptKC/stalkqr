collection = 'events'

class Events
	constructor: (db) ->
		db.bind collection,
			create: (event, callback) ->
				@.save event, safe:true, (err, res) ->
					callback()
		return db.events

exports.Events = Events