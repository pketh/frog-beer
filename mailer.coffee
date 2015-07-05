express = require 'express'
app = express()
path = require 'path'

database = require './database'
config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
signUpEmail = null

app.set 'views', path.join __dirname, 'templates'
app.set 'view engine', 'jade'

if process.env.NODE_ENV is 'development'
  url = "http://localhost:3000/"
else
  url = "http://frog.beer/"


renderSignUpEmail = (email, nickname, signUpToken, subject) ->
  app.render 'emails/sign-up',
    url: url
    email: email
    nickname: nickname
    signUpToken: signUpToken
    subject: subject
  ,
  (error, html) ->
    console.log html
    signUpEmail = html

mailer =

  sendSignUp: (emailRecipient, nickname, signUpToken) ->
    console.log "sending mail to #{nickname}"
    subject = '🐸 sup'
    renderSignUpEmail(emailRecipient, nickname, signUpToken, subject)

    sendgrid.send
      to: emailRecipient
      from: 'hi@frog.beer'
      replyTo: 'hi@pketh.org'
      subject: subject
      html: signUpEmail
      ,
      (error, status) ->
        console.log status

  # sendWeekly: from cron..
   # subject = thistopic + (re: lasttopic) if lasttopic
    # should I also do background colors based on art sampling (trello style). gridded colors..

module.exports = mailer
