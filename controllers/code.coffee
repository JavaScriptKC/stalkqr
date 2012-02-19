authentication = require './authentication'
codes = require '../models/codes'
event = require '../models/event'

module.exports = 
  use: (app) ->
    app.get '/generate', authentication.ensure, (req, res) ->
      event.list req.user.id, (err, events) ->
        res.render 'generate', 
          event_name: null
          events: events

    app.post '/generate', authentication.ensure, (req, res) ->
      generate_count = req.body.count
      event_name = req.body.event
      event.findByName req.user.id, event_name, (err, event) ->
        event.addCodes codes.generate(generate_count), ->
          res.redirect '/event/' + event_name

    app.get '/event/:event_name/generate', authentication.ensure, (req, res) ->
      event.list req.user.id, (err, events) ->
        res.render 'generate',
          event_name: req.params.event_name
          events: events
    
    app.get '/scan/:code', (req, res) ->
      res.redirect '/activate/' + req.params.code, 301

    app.get '/activate/:code', authentication.ensure, (req, res) ->
      res.render 'activate', code: req.params.code