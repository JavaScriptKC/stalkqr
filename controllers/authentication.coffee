passport = require 'passport'
strategies = require '../config/strategies'

ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

passport.use strategies.twitter

passport.use strategies.github

module.exports = (app) ->
	app.use passport.initialize()
  app.use passport.session()

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
  