colors = require 'colors'
uuid = require 'node-uuid'
_ = require 'underscore'

db = require './services/db'
mailer = require './mailer'

signInExistingUser = (email, nickname, signUpToken, response) ->
  db.Users.findAndModify
    query:
      email: email
    update:
      $set:
        name: nickname
        signUpToken: signUpToken
  ,
  (error, document) ->
    if error
      console.log error
    mailer.sendSignUp(email, nickname, signUpToken)
    response.sendStatus 200

createNewUser = (email, nickname, signUpToken, response) ->
  db.Users.update
    email: email
    {
      email: email
      name: nickname
      signUpToken: signUpToken
    },
    upsert: true
  ,
  (error, document) ->
    if error
      console.log error
    mailer.sendSignUp(email, nickname, signUpToken)
    response.sendStatus 200


users =

  signUp: (email, nickname, signUpToken, response) ->
    console.log "sign up w account token: #{signUpToken}".magenta
    db.Users.findOne
      email: email
    ,
    (error, document) ->
      if error
        console.log error
      else if document
        console.log 'Sign in existing user'.cyan
        signInExistingUser(email, nickname, signUpToken, response)
      else
        console.log 'Sign in new user'.cyan
        createNewUser(email, nickname, signUpToken, response)

  addAccountToken: (signUpToken, response) ->
    accountToken = uuid.v4()
    db.Users.findAndModify
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
      if error
        console.log error
      response.send accountToken

  getUserName: (accountToken, response) ->
    db.Users.findOne
      accountToken: accountToken
    ,
    (error, document) ->
      if error
        console.log error
      response.send document.name

  clearAccountTokens: (accountToken) ->
    db.Users.findAndModify
      query:
        accountTokens: accountToken
      update:
        $unset:
          accountTokens: ""
    ,
    (error, document) ->
      if error
        console.log error
      console.log "💣 #{document}"



module.exports = users
