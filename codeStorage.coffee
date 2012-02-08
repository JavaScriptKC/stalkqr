mongo = require 'mongoskin'

db = mongo.db('localhost:27017/linQR?auto_reconnect');
collection = 'codes'

db.bind collection,
	generate: (code, callback) ->
		@.insert code, safe:true, (err, objects) ->
			callback objects

db.bind collection,
	get: (id, callback) ->
		@.findById id, (err, res) -> 
			callback res

db.bind collection,
	setActive: (code, callback) ->
		code.Active = true
		@.save code, safe:true, (err, res) ->
			callback()

exports.Codes = db.codes