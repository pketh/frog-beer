async = require 'async'
later = require 'later'
later.date.UTC()

drawings = require '../drawings'
topics = require '../topics'
time = require './time'
mailer = require '../mailer'

scheduled =

  init: ->
    async.parallel [
      topics.getPreviousTopic
      topics.getCurrentTopic
    ], ->
      schedule = later.parse.text('every monday at 12:00am')
      # ! BUG ... later sends on startup , (also?)/not on schedule
      later.setInterval scheduled.weekly(), schedule

  weekly: ->
    topics.selectTopic()
    console.log "🍰 Topic for week ##{time.week} set to #{GLOBAL.currentTopic}"
    mailer.sendWeekly()

module.exports = scheduled
