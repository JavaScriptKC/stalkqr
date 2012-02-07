#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'
passport = require 'passport'
GitHubStrategy = require('passport-github').Strategy
TwitterStrategy = require('passport-twitter').Strategy;

TWITTER_CONSUMER_KEY = process.env.TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET = process.env.TWITTER_CONSUMER_SECRET
GITHUB_CLIENT_ID = process.env.GITHUB_CLIENT_ID
GITHUB_CLIENT_SECRET = process.env.GITHUB_CLIENT_SECRET

ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'
  return

passport.serializeUser (user, done) ->
  done(null, user);

passport.deserializeUser (obj, done) ->
  done(null, obj);

passport.use new GitHubStrategy {
    clientID: GITHUB_CLIENT_ID,
    clientSecret: GITHUB_CLIENT_SECRET,
    callbackURL: "http://127.0.0.1:3000/auth/github/callback"},
  (accessToken, refreshToken, profile, done) ->
    process.nextTick () ->
      done null, profile
    return

passport.use new TwitterStrategy {
    consumerKey: TWITTER_CONSUMER_KEY,
    consumerSecret: TWITTER_CONSUMER_SECRET,
    callbackURL: "http://127.0.0.1:3000/auth/twitter/callback"},
  (token, tokenSecret, profile, done) ->
    process.nextTick () ->
      done(null, profile)
    return

app.configure 'development', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public') }
  app.use express.logger { format: ':method :url' }
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session secret: 'nodekc hacking'
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static path.join(__dirname, 'public')

app.configure 'production', () ->
  app.use stylus.middleware { src: path.join(__dirname, 'public'), compress: true }
  app.use express.logger { format: ':method :url' }
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static path.join(__dirname, 'public')

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'index', res.data

app.get '/account', ensureAuthenticated, (req, res) ->
  res.render 'account', user: req.user
  
app.get '/login', (req, res) ->
  res.render 'login', res.data

app.get '/auth/github', passport.authenticate('github'), null

app.get '/auth/twitter', passport.authenticate('twitter'), null

app.get '/auth/github/callback', 
  passport.authenticate 'github', failureRedirect: '/login',
  (req, res) ->
    res.redirect '/'

app.get '/auth/twitter/callback', 
  passport.authenticate 'twitter', failureRedirect: '/login',
  (req, res) ->
    res.redirect '/'

app.get '/generate', (req, res) ->
  uuid = new Date().getTime()
  url = 'http://' + req.header('host') + '/scan/' + uuid

  res.render 'generate', url: url

app.get '/scan/:code', (req, res) ->
  res.redirect '/activate/' + req.params.code, 301

app.get '/activate/:code', (req, res) ->
  res.render 'activate', code: req.params.code

app.listen port

console.log 'server listening on port ' + port
