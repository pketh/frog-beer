colors = require 'colors'
moment = require 'moment'
uuid = require 'node-uuid'
_ = require 'underscore'

config = require './config.json'
mailer = require './mailer'
drawings = require './drawings'


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


users =


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

  # getUsers: array of objs: name? and email for use in weekly mail

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



module.exports = users
