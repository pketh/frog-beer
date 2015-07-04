sync = require 'sync'
config = require './config.json'
colors = require 'colors'
mongojs = require 'mongojs'

if process.env.NODE_ENV is 'development'
  path = "mongodb://#{config.devDB.user}:#{config.devDB.password}@#{config.devDB.path}"
  # console.log "mongo #{config.devDB.path} -u #{config.devDB.user} -p #{config.devDB.password}".cyan
else
  path = "mongodb://#{config.prodDB.user}:#{config.prodDB.password}@#{config.prodDB.path}"

db = mongojs path

collections = ->
  Users = db.collection 'Users'
  Drawings = db.collection 'Drawings'
  Drawings = db.collection 'Topics'


database =

  init: ->
    sync ->
      db.createCollection 'Users', {}
      db.createCollection 'Drawings', {}
      db.createCollection 'Topics', {}
      collections()


  newSignUp: (email, name, signUpToken) ->
    # var mycollection = db.collection('mycollection');
    # insert a sign up object
    console.log 'hi'.rainbow


module.exports = database
