express = require 'express'
path = require 'path'

config = require './config.json'
database = require './database' # unused for now
sendgrid = require('sendgrid')(config.sendgrid)

signUpEmail = null

app = express()
app.set 'views', path.join __dirname, 'templates'
app.set 'view engine', 'jade'

if process.env.NODE_ENV is 'development'
  url = "http://localhost:3000"
else
  url = "http://frog.beer"


renderSignUpEmail = (nickname, signUpToken, subject) ->
  console.log "rendering email for #{subject}"
  app.render 'emails/sign-up',
    subject: subject
    nickname: nickname
    url: url
    signUpUrl: "#{url}?sign-up-token=#{signUpToken}"
  ,
  (error, html) ->
    console.log html
    signUpEmail = html

mailer =

  sendSignUp: (emailRecipient, nickname, signUpToken) ->
    console.log "sending mail to #{nickname}"
    subject = '🐸 Confirm your account'
    renderSignUpEmail(nickname, signUpToken, subject)
    sendgrid.send
      to: emailRecipient
      from: 'frog@frog.beer'
      fromname: 'Frog Beer'
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
