express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
url = require 'url'
path = require 'path'
stylus = require 'stylus'
codes = require './controllers/codes'
event = require './models/event'

SESSION_SECRET = process.env.SESSION_SECRET || 'stalkqr'

app.configure ->
  app.use express.logger format: ':method :url :status'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: SESSION_SECRET
  app.use controllers.authentication(app)
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

app.get '/', (req, res) ->
  res.render 'index', 
    user: req.user
    isLoggedIn: req.isAuthenticated()

app.get '/generate', ensureAuthenticated, (req, res) ->
  event.list req.user.id, (err, events) ->
    res.render 'generate', 
      event_name: null
      events: events

app.post '/generate', ensureAuthenticated, (req, res) ->
  generate_count = req.body.count
  event_name = req.body.event
  event.findByName req.user.id, event_name, (err, event) ->
    event.addCodes codes.generate(generate_count), ->
      res.redirect '/event/' + event_name

app.get '/event/:event_name/generate', ensureAuthenticated, (req, res) ->
  event.list req.user.id, (err, events) ->
    res.render 'generate',
      event_name: req.params.event_name
      events: events
      
app.get '/event/new', ensureAuthenticated, (req, res) ->
  res.render 'events/new'

app.get '/event/:event_name', ensureAuthenticated, (req, res) ->
  event.findByName req.user.id, req.params.event_name, (err, event) ->
    res.render 'events/show',
      event: event 
      base_url: 'http://' + req.headers['host'] + '/scan/'

app.get '/events', ensureAuthenticated, (req, res) ->
  event.list req.user.id, (err, events) ->
    res.render 'events/list', events: events

app.post '/event', ensureAuthenticated, (req, res) ->
  event.create req.user.id, req.body.name, (err, event) ->
    res.redirect '/event/' + event.name

app.get '/scan/:code', (req, res) ->
  res.redirect '/activate/' + req.params.code, 301

app.get '/activate/:code', ensureAuthenticated, (req, res) ->
  res.render 'activate', code: req.params.code

app.listen port

console.log 'server listening on port ' + port