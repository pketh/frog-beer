express = require 'express'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
routes = require './routes'
app = express()

app.set 'views', path.join __dirname, 'templates'
app.set 'view engine', 'jade'
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use express.static path.join __dirname, 'public'

app.use routes
require('./errors')(app)

module.exports = app
