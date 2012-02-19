authentication = require './authentication'

generateUniqueIdentifier = (a, b) ->
  b = a = ""
  while a++ < 36
    b += (if a * 51 & 52 then (if a ^ 15 then 8 ^ Math.random() * (if a ^ 20 then 16 else 4) else 4).toString(16) else "-")
  b

generate = (count = 1) ->
  if count > 0 then (generateUniqueIdentifier() for x in [0...count]) else []
      
codes = 
  generate: generate

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