express = require 'express'
juice = require 'juice'
path = require 'path'
_ = require 'underscore'

config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
topics = require './topics'
drawings = require './drawings'
time = require './services/time'
db = require './services/db'

signUpEmail = null
weeklyEmail = null

app = express()
app.set 'view engine', 'jade'

renderSignUpEmail = (nickname, signUpToken, subject) ->
  console.log "rendering email for #{subject}"
  app.render 'emails/sign-up',
    subject: subject
    nickname: nickname
    url: GLOBAL.url
    signUpUrl: "#{url}?signUpToken=#{signUpToken}"
  ,
  (error, html) ->
    if error
      console.log error
    html = juice html, {applyWidthAttributes: true}
    signUpEmail = html

renderWeeklyEmail = (subject, drawingsInLastWeek) ->
  console.log "render weekly email for week ##{time.week}"
  app.render 'emails/weekly',
    subject: subject
    currentTopic: GLOBAL.currentTopic
    previousTopic: GLOBAL.previousTopic
    url: GLOBAL.url
    drawingsInLastWeek: _.shuffle drawingsInLastWeek
  ,
  (error, html) ->
    if error
      console.log error
    html = juice html, {applyWidthAttributes: true}
    weeklyEmail = html

sendMail = (email, subject, rendered) ->
  sendgrid.send
    to: email
    from: 'frog@frog.beer'
    fromname: 'Frog Beer'
    replyTo: 'hi@pketh.org'
    subject: subject
    html: rendered
    ,
    (error, status) ->
      if error
        console.log error
      console.log status


mailer =

  sendSignUp: (email, nickname, signUpToken) ->
    console.log "sending mail to #{nickname}"
    subject = '🐸 Confirm your account'
    renderSignUpEmail(nickname, signUpToken, subject)
    sendMail(email, subject, signUpEmail)

  sendWeekly: ->
    subject = "🐸 #{GLOBAL.currentTopic} + (re: #{GLOBAL.previousTopic})"
    drawingsInLastWeek = GLOBAL.drawingsInLastWeek
    renderWeeklyEmail subject, drawingsInLastWeek
    db.Users.find {}, {email: true, _id:false}, (error, users) ->
      if error
        console.log error
      emails = _.pluck(users, 'email')
      console.log emails
      sendMail(emails, subject, weeklyEmail)

module.exports = mailer
