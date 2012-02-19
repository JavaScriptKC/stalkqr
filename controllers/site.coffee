module.exports = 
  use: (app) ->
    app.get '/', (req, res) ->
      res.render 'index', 
        user: req.user
        isLoggedIn: req.isAuthenticated()