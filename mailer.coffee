express = require 'express'
juice = require 'juice'
path = require 'path'
sync = require 'sync'

config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
topics = require './topics'
drawings = require './drawings'

signUpEmail = null

app = express()
# app.set 'views', path.join __dirname, 'templates'
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

renderWeeklyEmail = (nickname) ->
  week = drawings.getWeekNumber()

  # sync ->
  #   topic = topics.getCurrentTopic()
  #   newTopic = topics.selectTopic()
  #   drawings = topics.getDrawingsForCurrentTopic() # array of paths
    # console.log "#{topic}, #{week}, #{newTopic}, #{drawings}"

  # app.render 'emails/weekly',
  #   subject: "🐸##{week}: #{newTopic}"
  #   newTopic: newTopic
  #   nickname: nickname
  #   topic: topic
  #   url: url
  # ,
  # (error, html) ->
  #   if error
  #     console.log error
  #   html = juice html, {applyWidthAttributes: true}
  #   WeeklyEmail = html


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

  sendWeekly: () ->
    renderWeeklyEmail('joe')
  # sendWeekly: starts here - from cron.. sunday midnight or monday morning..
   # subject = thistopic + (re: lasttopic) if lasttopic
    # should I also do background colors based on art sampling (trello style). gridded colors..

module.exports = mailer

# mailer.sendWeekly()
