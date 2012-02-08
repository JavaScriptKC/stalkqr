#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'
storage = require './storage'
janrain = require 'janrain-api'

engageAPI = janrain 'd2f59eb384bb820fa102e8dd67229f08adbe9e8a'

app.configure ->
  app.use express.logger { format: ':method :url' }
  app.use express.static path.join(__dirname, 'public')
  app.use express.cookieParser()
  app.use express.session secret: 'nodekc'
  app.use express.bodyParser()

app.configure 'development', ->
  app.use stylus.middleware { src: path.join(__dirname, 'public') }

app.configure 'production', ->
  app.use stylus.middleware { src: path.join(__dirname, 'public'), compress: true }

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  loggedIn  = req.session.authId?
  res.render 'index', {userName: req.session.authId, loggedIn: loggedIn}

app.post '/authCallback', (req,res) ->
  engageAPI.authInfo req.body.token, true, (err, data) ->
    if err
      console.log 'ERROR: ' + err.message

    authId = data.profile.identifier

    completeLogin = ->
        req.session.authId = authId
        res.redirect '/', 301

    storage.Users.exists authId, (exists) ->
      if exists
        completeLogin()
      else
        userStorage.Users.create
          authId: authId, 
          firstName: data.profile.name.givenName, 
          lastName: data.profile.name.familyName, 
          email: data.profile.email
          ->
            completeLogin()

app.get '/signout', (req, res) ->
  delete req.session.authId
  res.redirect '/', 301

app.post '/generate', (req, res) ->
  storage.Codes.generate {}, (created) ->
    localUrl = 'http://' + req.header('host') + '/scan/' + created[0]._id
    qrImgUrl = "https://chart.googleapis.com/chart?cht=qr&chs=128x128&chl=" + localUrl
    res.send url: qrImgUrl

app.get '/scan/:id', (req, res) ->
  storage.Codes.get req.params.id, (code) ->
    if !code?
      res.render 'invalidCode', id: req.params.id
    else if code.Active
      res.redirect '/connect/' + req.params.id, 301
    else
      res.redirect '/activate/' + req.params.id, 301

app.get '/activate/:id', (req, res) ->
  storage.Codes.get req.params.id, (code) ->
    if !code?
      res.render 'invalidCode', id:req.params.id
    else if code.Active
      res.redirect '/connect/' + req.params.id, 302
    else
      res.render 'activate', id: req.params.id

app.post '/activate/:id', (req, res) ->
  storage.Codes.get req.params.id, (code) ->
    if !code?
      res.send result:false, message: id:req.params.id + ' is an invalid code'
    else if code.Active
      res.send result:true
    else
      storage.Codes.setActive code, ->
        res.send result:true

app.get '/connect/:id', (req,res) ->
  storage.Codes.get req.params.id, (code) ->
    if !code?
      res.render 'invalidCode', id: req.params.id
    else if code.Active
      res.render 'connect'
    else
      res.redirect '/activate/' + req.params.id, 301

app.listen port

console.log 'server listening on port ' + port
