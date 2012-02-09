#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'
codes = require './controllers/codes'

app.configure 'development', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public') }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join(__dirname, 'public')

app.configure 'production', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public'), compress: true }
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join(__dirname, 'public')

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'layout', res.data

app.get '/generate', (req, res) ->
  data = codes.generateOne req.header ('host')
  res.render 'generate', data

app.get '/generate/:number', (req, res) ->
  data = codes.generateMany(req.header('host'), req.params.number, null)
  res.render 'generate_bulk', data

app.get '/generate/event/:event', (req, res) ->
  data = codes.generateOne(req.header('host'), req.params.event)
  console.log data
  res.render 'generate', data

app.get '/generate/:number/event/:event', (req, res) ->
  data = codes.generateMany(req.header('host'), req.params.number, req.params.event)
  res.render 'generate_bulk', data
  
app.get '/scan/:code', (req, res) ->
  res.redirect '/activate/' + req.params.code, 301

app.get '/activate/:code', (req, res) ->
  res.render 'activate', code: req.params.code

app.get '/scan/:event/:code',

app.listen port

console.log 'server listening on port ' + port
