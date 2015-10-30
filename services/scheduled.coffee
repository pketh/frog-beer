async = require 'async'
later = require 'later'
later.date.UTC()

drawings = require '../drawings'
topics = require '../topics'
time = require './time'

scheduled =

  init: ->
    async.series [
      topics.getPreviousTopic
      topics.getCurrentTopic
    ], ->
      schedule = later.parse.text('every monday at 12:00am')
      later.setInterval scheduled.weekly(), schedule

  weekly: ->
    console.log "hi #{GLOBAL.currentTopic}"
    topics.selectTopic()
    console.log "🍰 Topic for week ##{time.week} set to #{GLOBAL.currentTopic}"


module.exports = scheduled
