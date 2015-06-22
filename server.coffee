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
emails = require './emails'
sendgrid = require('sendgrid')(config.sendgrid)

if process.env.NODE_ENV is 'development'
  frogBeer = 'localhost:3000'
else
  frogBeer = 'frog.beer'

passwordless.init new MongoStore frogDB.path,
  server:
    auto_reconnect: true
  mongostore:
    collection: 'tokens'

passwordless.addDelivery (tokenToSend, uidToSend, recipient, callback) ->
  # .. make message a jade template w inline styles
  # https://www.npmjs.com/package/email-templates
  # or find a way to render a render./emails/welcome and put the rendered output in as a node var
  message =
  sendgrid.send
    to      : uidToSend
    from    : emails.from
    subject : emails.welcome.subject
    text    : emails.welcome.message(frogBeer, tokenToSend, uidToSend)


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
app.use passwordless.sessionSupport()
app.use passwordless.acceptToken
  successRedirect: '/'

app.use routes
require('./errors')(app)

module.exports = app
