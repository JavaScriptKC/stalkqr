express = require 'express'
url = require 'url'
path = require 'path'
stylus = require 'stylus'
app = express.createServer()
port = process.env.PORT || 3000
sessionSecret = process.env.SESSION_SECRET || 'stalkqr'

controllers = 
  authentication: require './controllers/authentication'
  site: require './controllers/site'
  code: require './controllers/code'
  event: require './controllers/event'

app.configure ->
  app.use express.logger format: ':method :url :status'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: sessionSecret
  app.use express.static path.join __dirname, 'public'
  app.set 'views', path.join __dirname, 'views'
  app.set 'view engine', 'jade'

app.configure 'development', ->
  app.use stylus.middleware 
    src: path.join __dirname, 'public' 
  
app.configure 'production', ->
  app.use stylus.middleware 
    src: path.join __dirname, 'public' 
    compress: true

controllers.authentication.use app
controllers.site.use app
controllers.code.use app
controllers.event.use app

app.listen port

console.log 'server listening on port ' + port