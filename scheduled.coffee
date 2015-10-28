drawings = require './drawings'
topics = require './topics'

scheduled =

  weekly: ->
    # drawings.createCurrentWeekPath()
    topics.selectTopic()
    console.log topics.getCurrentTopic()


module.exports = scheduled

scheduled.weekly()
