express = require 'express'

app = express()
app.use express.static(__dirname + '/public')
app.use require('connect-assets')()
app.set('view engine', 'jade')

app.get '/', (req, res) ->
  res.render 'index'

app.listen 8080, ->
  console.log 'Express server listening on port 8080.'
