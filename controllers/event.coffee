authentication = require './authentication'
event = require '../models/event'

module.exports = 
  use: (app) ->
    app.get '/event/new', authentication.ensure, (req, res) ->
      res.render 'events/new'

    app.get '/event/:event_name', authentication.ensure, (req, res) ->
      event.findByName req.user.id, req.params.event_name, (err, event) ->
        res.render 'events/show',
          event: event 
          base_url: 'http://' + req.headers['host'] + '/scan/'

    app.get '/events', authentication.ensure, (req, res) ->
      event.list req.user.id, (err, events) ->
        res.render 'events/list', events: events

    app.post '/event', authentication.ensure, (req, res) ->
      event.create req.user.id, req.body.name, (err, event) ->
        res.redirect '/event/' + event.name