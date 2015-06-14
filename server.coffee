express = require 'express'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
routes = require './routes'
passwordless = require 'passwordless'
MongoStore = require 'passwordless-mongostore'

frogDB = require './frogDB'
console.log frogDB.path
console.log process.env.NODE_ENV


# passwordless.init(artistTokenDB)
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
