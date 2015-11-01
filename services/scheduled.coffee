Agenda = require 'agenda'
async = require 'async'

drawings = require '../drawings'
topics = require '../topics'
time = require './time'
mailer = require '../mailer'

scheduled =

  init: ->
    async.parallel [
      topics.getPreviousTopic
      topics.getCurrentTopic
      drawings.updateDrawingsInLastWeek
    ], ->
      console.log "🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸  🐸"

  weekly: ->
    async.series [
      topics.selectTopic
      mailer.sendWeekly
    ], ->
      console.log "🍰 schedule.weekly complete"

module.exports = scheduled

agenda = new Agenda
  db:
    address: GLOBAL.mongoURL
    collection: 'Agenda'
    options:
      server:
        auto_reconnect: true

agenda.define 'schedule.weekly', (job, done) ->
  scheduled.weekly()

agenda.on 'ready', ->
  agenda.every '1 week', 'schedule.weekly'
  agenda.start()
