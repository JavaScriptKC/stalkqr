express = require 'express'
path = require 'path'
stylus = require 'stylus'

site = require './controllers/site'
codes = require './controllers/codes'

app = express.createServer()
port = process.env.PORT || 3000

app.configure 'development', () ->
  app.use stylus.middleware { src: path.join __dirname, 'public' }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join __dirname, 'public'

app.configure 'production', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public'), compress: true }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join __dirname, 'public'

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.get '/', site.index

app.get '/generate', codes.generate
app.get '/scan/:code', codes.scan
app.get '/activate/:code', codes.activate

app.listen port

console.log 'server listening on port ' + port
