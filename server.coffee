express = require 'express'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
routes = require './routes'
passwordless = require 'passwordless'
MongoStore = require 'passwordless-mongostore'
frogDB = require './frogDB'
config = require './config.json'


passwordless.init new MongoStore frogDB.path,
  server:
    auto_reconnect: true
  mongostore:
    collection: 'tokens'

# passwordless.addDelivery (tokenToSend, uidToSend, recipient, callback) ->
  # send out a token

app = express()
app.set 'views', path.join __dirname, 'templates'
app.set 'view engine', 'jade'
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use express.static path.join __dirname, 'public'
app.use session
  secret: config.secret
app.use passwordless.sessionSupport()
app.use passwordless.acceptToken()

app.use routes
require('./errors')(app)

module.exports = app
