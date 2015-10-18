bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
express = require 'express'
logger = require 'morgan'
colors = require 'colors'
path = require 'path'
session = require 'express-session'
limiter = require('express-limiter') app

config = require './config.json'
# topics = require './topics'
# users = require './users'
routes = require './routes'
db = require './db'

app = express()
app.set 'view engine', 'jade'
app.use logger 'dev' # use prod for env?
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use express.static './public'
app.use session
  secret: config.frogSecret
  resave: false
  saveUninitialized: false

app.use routes

app.use (request, response, next) ->
  error = new error 'Not Found'
  error.status = 404
  next error

if app.get('env') is 'development'
  app.use (error, request, response, next) ->
    response.status error.status or 500
    response.render 'error',
      message: error.message
      error: error
else
  app.use (error, request, response, next) ->
    response.status error.status or 500
    response.render 'error',
      message: error.message
      error: {}


module.exports = app

limiter {
  path: '*'
  lookup: 'connection.remoteAddress'
}
