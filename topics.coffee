Trello = require 'node-trello'
_ = require 'underscore'
colors = require 'colors'

config = require './config.json'
drawings = require './drawings'
dropbox = require './services/dropbox'
time = require './services/time'
db = require './services/db'
trello = new Trello(config.trello.key, config.trello.token)

board = '55458e45bbd7364c39f36b54'
upcomingTopicsList = '55458e8002d6d526cff3ff10'
pastTopicsList = '55458ea267f62bfd5cb3fb13'

topics =

  selectTopic: ->
    options = {cards: 'open', card_fields: 'name'}
    trello.get "/1/lists/#{upcomingTopicsList}", options, (error, data) ->
      if error
        console.log error
      cards = data.cards
      shuffled = _.shuffle cards
      topic = shuffled[0]
      topics.saveTopic topic.name
      topics.moveTopicToPastTopics topic
      return topic.name

  moveTopicToPastTopics: (card) ->
    options = {value: pastTopicsList}
    trello.put "/1/cards/#{card.id}/idList", options, (error, data) ->
      if error
        console.log error
      console.log "card is now old: #{card.name}"
      # console.log data

  getPreviousTopic: (callback) ->
    db.Topics.findOne
      week: time.lastWeek
    ,
    (error, previousTopic) ->
      if error
        console.log error
      console.log "PREVIOUS TOPIC".yellow
      console.log previousTopic.topic
      GLOBAL.previousTopic = previousTopic.topic
      callback null

  getCurrentTopic: (callback) ->
    db.Topics.findOne
      week: time.currentWeek
    ,
    (error, currentTopic) ->
      if error
        console.log error
      console.log "CURRENT TOPIC".yellow
      console.log currentTopic.topic
      GLOBAL.currentTopic = currentTopic.topic
      callback null

  saveTopic: (topic) ->
    dropbox.writeFile "#{time.currentWeek}/topic-#{topic}.txt", topic, (error, data) ->
      if error
        console.log error
      db.Topics.save {
          week: time.currentWeek
          topic: topic
        }
      ,
      (error, document) ->
        if error
          console.log error
        console.log "topic set as #{topic}"
        console.log document


module.exports = topics
