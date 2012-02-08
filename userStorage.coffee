collection = 'users'

class Users
	constructor: (db) ->
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
		return db.users

exports.Users = Users