colors = require 'colors'
moment = require 'moment'
mongojs = require 'mongojs'
sync = require 'sync'
uuid = require 'node-uuid'
_ = require 'underscore'

config = require './config.json'
mailer = require './mailer'
[Users, Drawings, Topics] = [null]

if process.env.NODE_ENV is 'development'
  path = "mongodb://#{config.devDB.user}:#{config.devDB.password}@#{config.devDB.path}"
  # console.log "mongo #{config.devDB.path} -u #{config.devDB.user} -p #{config.devDB.password}".cyan
else
  path = "mongodb://#{config.prodDB.user}:#{config.prodDB.password}@#{config.prodDB.path}"
  console.log "mongo #{config.prodDB.path} -u #{config.prodDB.user} -p #{config.prodDB.password}".cyan

db = mongojs path

collections = ->
  Users = db.collection 'Users'
  Drawings = db.collection 'Drawings'
  Topics = db.collection 'Topics'

signInExistingUser = (email, nickname, signUpToken, response) ->
  Users.findAndModify
    query:
      email: email
    update:
      $set:
        name: nickname
        signUpToken: signUpToken
  ,
  (error, document) ->
    mailer.sendSignUp(email, nickname, signUpToken)

createNewUser = (email, nickname, signUpToken, response) ->
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
    mailer.sendSignUp(email, nickname, signUpToken)
    response.send true


database =

  init: ->
    sync ->
      db.createCollection 'Users', {}
      db.createCollection 'Drawings', {}
      db.createCollection 'Topics', {}
      collections()

  newSignUp: (email, nickname, signUpToken, response) ->
    console.log "account token: #{signUpToken}".magenta
    Users.findOne
      email: email
    ,
    (error, document) ->
      if document
        signInExistingUser(email, nickname, signUpToken, response)
      else
        createNewUser(email, nickname, signUpToken, response)

  addAccountToken: (signUpToken, response) ->
    accountToken = uuid.v4()
    Users.findAndModify
      query:
        signUpToken: signUpToken
      update:
        $set:
          accountConfirmed: true
          signUpToken: null
        $push:
          accountTokens: accountToken
    ,
    (error, document) ->
      if document
        response.send accountToken

  getUserName: (accountToken, response) ->
    Users.findOne
      accountToken: accountToken
    ,
    (error, document) ->
      if document
        response.send document.name

  clearAccountTokens: (accountToken) ->
    Users.findAndModify
      query:
        accountTokens: accountToken
      update:
        $unset:
          accountTokens: ""
    ,
    (error, document) ->
      if document
        console.log "💣"


module.exports = database
