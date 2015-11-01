Agenda = require 'agenda'
async = require 'async'
# later = require 'later'
# later.date.UTC()
# crontab = require 'crontab'

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
    ]
    # , ->
      # schedule = later.parse.text('every monday at 12:00am')
      # ! BUG ... later sends on startup , (also?)/not on schedule
      # later.setTimeout scheduled.weekly(), schedule

  weekly: ->
    async.series [
      topics.selectTopic
      # console.log "🍰 Topic for week ##{time.week} set to #{GLOBAL.currentTopic}"
      # console.log "drawings for last week are : #{GLOBAL.drawingsInLastWeek}"
      mailer.sendWeekly
    ], ->
      console.log "🍰 Weekly tasks complete"

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

# scheduled.weekly()
