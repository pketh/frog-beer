later = require 'later'
later.date.UTC()

drawings = require '../drawings'
topics = require '../topics'
time = require './time'

schedule = later.parse.text('every monday at 12:00am')

scheduled =

  weekly: ->
    topics.selectTopic()
    console.log "🍰 Topic for week ##{time.week} set to #{topics.getCurrentTopic()}"


module.exports = scheduled

later.setInterval scheduled.weekly(), schedule
