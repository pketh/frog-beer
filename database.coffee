colors = require 'colors'
moment = require 'moment'
mongojs = require 'mongojs'
sync = require 'sync'

config = require './config.json'
[Users, Drawings, Topics] = [null]

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

  newSignUp: (email, nickname, signUpToken, response) ->
    Users.update
      email: email
      {
        email: email
        name: nickname
        signUpToken: signUpToken
      },
      upsert: true
    ,
    (error, document) ->
      console.log document
      # TODO email signUpToken to email
      response.send true


module.exports = database
