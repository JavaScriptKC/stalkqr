express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
url = require 'url'
path = require 'path'
stylus = require 'stylus'
uuid = require 'node-uuid'
passport = require 'passport'
GitHubStrategy = require('passport-github').Strategy
TwitterStrategy = require('passport-twitter').Strategy;

event_code_map = {}

TWITTER_CONSUMER_KEY = process.env.TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET = process.env.TWITTER_CONSUMER_SECRET
TWITTER_CALLBACK_URL = url.resolve process.env.CALLBACK_BASE_URL, '/auth/twitter/callback'

GITHUB_CLIENT_ID = process.env.GITHUB_CLIENT_ID
GITHUB_CLIENT_SECRET = process.env.GITHUB_CLIENT_SECRET
GITHUB_CALLBACK_URL = url.resolve process.env.CALLBACK_BASE_URL, '/auth/github/callback'

SESSION_SECRET = process.env.SESSION_SECRET || 'stalkqr'

ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'

passport.serializeUser (user, done) ->
  done(null, user);

passport.deserializeUser (obj, done) ->
  done(null, obj);

twitterDone = (accessToken, refreshToken, profile, done) ->
  done null, profile

passport.use new GitHubStrategy
  clientID: GITHUB_CLIENT_ID
  clientSecret: GITHUB_CLIENT_SECRET
  callbackURL: GITHUB_CALLBACK_URL
  twitterDone

githubDone = (accessToken, tokenSecret, profile, done) ->
  done null, profile

passport.use new TwitterStrategy
  consumerKey: TWITTER_CONSUMER_KEY
  consumerSecret: TWITTER_CONSUMER_SECRET
  callbackURL: TWITTER_CALLBACK_URL
  githubDone

app.configure () ->
  app.use express.logger format: ':method :url :status'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: SESSION_SECRET
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static path.join __dirname, 'public'
  app.set 'views', path.join __dirname, 'views'
  app.set 'view engine', 'jade'

app.configure 'development', () ->
  app.use stylus.middleware 
    src: path.join __dirname, 'public' 
  
app.configure 'production', () ->
  app.use stylus.middleware 
    src: path.join __dirname, 'public' 
    compress: true

app.get '/', (req, res) ->
  res.render 'index', 
    user: req.user
    isLoggedIn: req.isAuthenticated()

app.get '/account', ensureAuthenticated, (req, res) ->
  res.render 'account', user: req.user
  
app.get '/login', (req, res) ->
  res.render 'login', res.data

app.get '/auth/github', passport.authenticate('github')

app.get '/auth/twitter', passport.authenticate('twitter')

app.get '/auth/github/callback', 
  passport.authenticate('github', failureRedirect: '/login'), (req, res) ->
    res.redirect '/'

app.get '/auth/twitter/callback', 
  passport.authenticate('twitter', failureRedirect: '/login'), (req, res) ->
    res.redirect '/'

app.get '/generate', (req, res) ->
  uuid = new Date().getTime()
  url = 'http://' + req.header('host') + '/scan/' + uuid
  res.render 'generate', url: url

app.get '/scan/:code', (req, res) ->
  res.redirect '/activate/' + req.params.code, 301

app.get '/activate/:code', (req, res) ->
  res.render 'activate', code: req.params.code

app.post '/generate', (req, res) ->
  codes = (uuid.v4() for number  in [0...req.body.number])
  event_code_map[req.body.event_id] or= []
  event_code_map[req.body.event_id].concat codes
  res.render 'generateBatch', codes: codes

app.listen port

console.log 'server listening on port ' + port

