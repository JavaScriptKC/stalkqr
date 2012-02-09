#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'
uuid = require 'node-uuid'
event_code_map = {}

app.configure 'development', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public') }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join(__dirname, 'public')
  app.use express.bodyParser()

app.configure 'production', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public'), compress: true }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join(__dirname, 'public')

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'layout', res.data

app.get '/generate', (req, res) ->
  res.render 'generateForm'

  # post /event/
  # attrs: name
  # get /event/:id/:code

  # post /generate
  # attr: event_id, number
app.post '/generate', (req, res) ->
  codes = (uuid.v4() for number  in [0...req.body.number])
  event_code_map[req.body.event_id] or= []
  event_code_map[req.body.event_id].concat codes
  res.render 'generateBatch', codes: codes

app.get '/scan/:code', (req, res) ->
  res.redirect '/activate/' + req.params.code, 301

app.get '/activate/:code', (req, res) ->
  res.render 'activate', code: req.params.code

app.listen port

console.log 'server listening on port ' + port

