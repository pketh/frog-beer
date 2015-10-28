later = require 'later'
later.date.UTC()

drawings = require './drawings'
topics = require './topics'

schedule = later.parse.text('every monday at 12:00am')

scheduled =

  weekly: ->
    # drawings.createCurrentWeekPath()
    topics.selectTopic()
    console.log topics.getCurrentTopic()


module.exports = scheduled

later.setInterval scheduled.weekly(), schedule
