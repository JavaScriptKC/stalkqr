codes =
  generate: (request, response) ->
    uuid = new Date().getTime()
    url = 'http://' + request.header('host') + '/scan/' + uuid
    response.render 'generate', url: url

  scan: (request, response) ->
    response.redirect '/activate/' + request.params.code, 301

  activate: (request, response) ->
    response.render 'activate', code: request.params.code

module.exports = codes