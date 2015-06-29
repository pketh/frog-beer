express = require 'express'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
routes = require './routes'
frogDB = require './frogDB'
config = require './config.json'
mailer = require './mailer'

if process.env.NODE_ENV is 'development'
  frogBeer = 'localhost:3000'
else
  frogBeer = 'frog.beer'

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
  secret: config.frogSecret
  resave: false
  saveUninitialized: false

app.use routes
require('./errors')(app)

module.exports = app
