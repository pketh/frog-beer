bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
express = require 'express'
logger = require 'morgan'
colors = require 'colors'
path = require 'path'
session = require 'express-session'
limiter = require('express-limiter') app
mongojs = require 'mongojs'
sync = require 'sync'

config = require './config.json'
# topics = require './topics'
# users = require './users'
routes = require './routes'
[Users, Drawings, Topics] = [null]

path = "mongodb://#{config.mongo.user}:#{config.mongo.password}@#{config.mongo.path}"
console.log "mongo #{config.mongo.path} -u #{config.mongo.user} -p #{config.mongo.password}".magenta

db = mongojs path

collections = ->
  Users = db.collection 'Users'
  Drawings = db.collection 'Drawings'
  Topics = db.collection 'Topics'

sync ->
  db.createCollection 'Users', {}
  db.createCollection 'Drawings', {}
  db.createCollection 'Topics', {}
  collections()


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
