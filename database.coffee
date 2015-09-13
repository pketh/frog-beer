colors = require 'colors'
moment = require 'moment'
mongojs = require 'mongojs'
sync = require 'sync'
uuid = require 'node-uuid'
_ = require 'underscore'

config = require './config.json'
mailer = require './mailer'
drawings = require './drawings'
[Users, Drawings, Topics] = [null]

path = "mongodb://#{config.mongo.user}:#{config.mongo.password}@#{config.mongo.path}"
console.log "mongo #{config.mongo.path} -u #{config.mongo.user} -p #{config.mongo.password}".rainbow

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
    response.send true

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

  addTopic: (topic) ->
    Topics.save {
        week: drawings.getCurrentTopic()
        topic: topic
      }
    ,
    (error, document) ->
      if document
        console.log document


module.exports = database
