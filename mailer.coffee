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

#
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
    newTopic: GLOBAL.currentTopic
    previousTopic: GLOBAL.previousTopic
    url: url
    drawings: drawingsInLastWeek #array of imgs or abs paths
  ,
  (error, html) ->
    if error
      console.log error
    html = juice html, {applyWidthAttributes: true}
    weeklyEmail = html


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
        if error
          console.log error
        else
          console.log status

  sendWeekly: ->
    console.log "send weekly mail to everyone"
    subject = "🐸 #{GLOBAL.currentTopic} + (re: #{GLOBAL.previousTopic})"
    console.log subject

    drawingsInLastWeek = drawings.getDrawingsInLastWeek()
    console.log "DRAWINGS"
    # console.log drawingsInLastWeek

    renderWeeklyEmail(subject, drawingsInLastWeek)

    db.Users.find {}, {email: true, _id:false}, (error, users) ->
      if error
        console.log error
      else
        emails = _.pluck(users, 'email')
        console.log emails

        sendgrid.send
          to: emails
          from: 'frog@frog.beer'
          fromname: 'Frog Beer'
          replyTo: 'hi@pketh.org'
          subject: subject
          html: weeklyEmail
          ,
          (error, status) ->
            if error
              console.log error
            else
              console.log status


module.exports = mailer

# mailer.sendWeekly()
