internal =
  generate: (code, host, render) ->
    url = 'http://' + host + '/scan/' + code
    render 'codes/generate', url: url

  scan: (code, redirect) ->
    url = '/activate/' + code
    redirect url, temporarily = 301

  activate: (request, response) ->
    response.render 'activate', code: request.params.code

module.exports =
  _internal: internal,

  scan: (request, response) ->
    code = request.params.code

    _internal.scan code, response.redirect

  generate: (request, response) ->
    code = new Date().getTime()
    host = request.header 'host'
    render = response.render

    _internal.generate code, host, render