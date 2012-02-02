#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'
bitly = require './bitly'

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

app.get '/:user/:code', bitly.claim, (req, res) ->
  res.render 'layout', res.data

app.get '/generate', bitly.generate, (req, res) ->
  res.render 'layout', res.data
  
app.listen port

console.log 'server listening on port ' + port
