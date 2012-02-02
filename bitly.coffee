rest = require 'restler'
api_username = process.ENV.BITLY_USERNAME
api_key = process.ENV.BITLY_API_KEY
generated_urls = {}

module.exports = {
  generate: (req, res, next) ->
    uuid = (new Date).getTime()
    username = 'dummy'
    host = req.header('host').replace('localhost', '127.0.0.1')
    url = encodeURIComponent('http://' + host + '/' + username + '/' + uuid)

    bitly_url = "https://api-ssl.bitly.com/v3/shorten?login=" + api_username + "&apiKey=" + api_key + "&longUrl=#{url}&format=json"
    
    rest.get(bitly_url).on('complete', (response) ->       
      res.data or= {}
      res.data.bitly = response.data
      generated_urls[username + uuid] = res.data.bitly
      next()
    )
    
  claim: (req, res, next) ->
    res.data or= {}
    
    bitly_data = generated_urls[req.params.user + req.params.code]

    res.data.encounter = 
      username: req.params.user
      code: req.params.code
      referrer: if bitly_data? then bitly_data.url else 'Unknown'
    next()
}