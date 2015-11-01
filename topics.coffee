async = require 'async'
mkdirp = require 'mkdirp'
fs = require 'fs'
Trello = require 'node-trello'
_ = require 'underscore'
colors = require 'colors'
kaomoji = require 'kaomoji'

config = require './config.json'
drawings = require './drawings'
time = require './services/time'
db = require './services/db'
s3 = require './services/s3'

trello = new Trello(config.trello.key, config.trello.token)
board = '55458e45bbd7364c39f36b54'
upcomingTopicsList = '55458e8002d6d526cff3ff10'
pastTopicsList = '55458ea267f62bfd5cb3fb13'

topics =

  getPreviousTopic: (callback) ->
    db.Topics.findOne
      week: time.lastWeek
    ,
    (error, previousTopic) ->
      if error
        console.log error
      if previousTopic
        console.log "PREVIOUS TOPIC".yellow
        console.log previousTopic.topic
        GLOBAL.previousTopic = previousTopic.topic
      else
        GLOBAL.previousTopic = "Abstractions"
      callback null

  getCurrentTopic: (callback) ->
    db.Topics.findOne
      week: time.currentWeek
    ,
    (error, currentTopic) ->
      if error
        console.log error
      if currentTopic
        console.log "CURRENT TOPIC".yellow
        console.log currentTopic.topic
        GLOBAL.currentTopic = currentTopic.topic
        callback null
      else
        async.series [
          topics.selectTopic
          topics.getCurrentTopic
        ]

  selectTopic: (callback) ->
    options = {cards: 'open', card_fields: 'name'}
    trello.get "/1/lists/#{upcomingTopicsList}", options, (error, data) ->
      if error
        console.log error
      cards = data.cards
      shuffled = _.shuffle cards
      topic = shuffled[0]
      topics.saveTopic topic, callback

  moveTopicCardToPastTopics: (card, callback) ->
    options = {value: pastTopicsList}
    trello.put "/1/cards/#{card.id}/idList", options, (error, data) ->
      if error
        console.log error
      console.log "card is now old: #{card.name}"
      callback null

  saveTopicLocally: (file, path, callback) ->
    localPath = "#{path}/#{file}"
    mkdirp path, (error) ->
      if error
        console.log error
      fs.writeFile localPath, kaomoji.happy(), (error) ->
        if error
          console.log error
        console.log "#{file} saved".green
        callback null

  saveTopicToS3: (file, path, remotePath, callback) ->
    params =
      localFile: "#{path}/#{file}"
      s3Params:
        Bucket: "frog-beer"
        Key: remotePath
        ACL: "public-read"
    upload = s3.uploadFile params
    upload.on 'error', (error) ->
      console.log error
    upload.on 'end', ->
      console.log "Topic Uploaded to S3".green
      callback null

  saveTopicToDB: (topic) ->
    db.Topics.save {
        week: time.currentWeek
        topic: topic
      }
    ,
    (error, document) ->
      if error
        console.log error
      console.log "topic set as #{topic}"

  saveTopic: (topic, callback) ->
    file = "topic-#{topic.name}.txt"
    path = "./public/blobs/#{time.currentWeek}"
    remotePath = "#{time.currentWeek}/#{file}"
    card = topic
    async.series [
      async.apply topics.saveTopicLocally, file, path
      async.apply topics.saveTopicToS3, file, path, remotePath
    ], ->
      topics.saveTopicToDB topic.name
      topics.moveTopicCardToPastTopics card, callback

module.exports = topics
