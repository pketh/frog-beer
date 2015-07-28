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
db = mongojs path

collections = ->
  Users = db.collection 'Users'
  Drawings = db.collection 'Drawings'
  Topics = db.collection 'Topics'

#temp
# clearSignUpToken = (document) ->
#   id = mongojs.ObjectId(document._id)
#   Users.update
#     _id: id
#     {
#       signUpToken: null
#     }


database =

  init: ->
    sync ->
      db.createCollection 'Users', {}
      db.createCollection 'Drawings', {}
      db.createCollection 'Topics', {}
      collections()
      # Users.find (err, docs) ->
      #   console.log docs

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
      mailer.sendSignUp(email, nickname, signUpToken)
      response.send true

  # if token matches an email acct from the db, a cookie is set w a login token
  addAccountToken: (signUpToken, response) ->
    accountToken = uuid.v4()
    Users.findAndModify
      query:
        signUpToken: signUpToken
      update:
        $push:
          accountToken: accountToken
        # TODO signUpToken: null
      upsert: true
    ,
    (error, document) ->
      response.send
        email: document.email
        accountToken: _.last document.accountToken
      # temp : clearSignUpToken(document)


module.exports = database
