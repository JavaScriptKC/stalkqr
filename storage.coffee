mongo = require 'mongoskin'

db = mongo.db('localhost:27017/linQR?auto_reconnect');

exports.Codes = new(require('./codeStorage').Codes)(db)
exports.Users = new(require('./userStorage').Users)(db)
exports.Events = new(require('./eventStorage').Events)(db)