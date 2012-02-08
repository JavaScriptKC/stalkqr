mongo = require 'mongoskin'

db = mongo.db('localhost:27017/linQR?auto_reconnect');
collection = 'users'

db.bind collection,
	create: (user, callback) ->
		user.SignupOn ?= new Date()
		@.save user, safe:true, (err, res) ->
			callback()

db.bind collection,
	exists: (id, callback) ->
		@.findOne authId: id, (err, res) ->
			console.log res
			callback res?

exports.Users = db.users