Trello = require 'node-trello'
_ = require 'underscore'

config = require './config.json'
trello = new Trello(config.trello.key, config.trello.token)

board = '55458e45bbd7364c39f36b54'
upcomingTopicsList = '55458e8002d6d526cff3ff10'
pastTopicsList = '55458ea267f62bfd5cb3fb13'

topics =

  getTrelloAccountInfo: ->
    trello.get "/1/members/me", (error, data) ->
      if error
        console.log error
      console.log data

  getBoardInfo: ->
    trello.get "/1/boards/#{board}", (error, data) ->
      if error
        console.log error
      console.log "info for board: #{data.name}:"
      console.log data

  getLists: ->
    options = {lists: 'open', list_fields: 'name'}
    trello.get "/1/boards/#{board}", options, (error, data) ->
      if error
        console.log error
      console.log data

  selectTopic: ->
    options = {cards: 'open', card_fields: 'name'}
    trello.get "/1/lists/#{upcomingTopicsList}", options, (error, data) ->
      if error
        console.log error
      cards = data.cards
      shuffled = _.shuffle cards
      topic = shuffled[0]
      drawings.saveTopic topic.name
      topics.moveTopicToPastTopics topic
      return topic.name

  moveTopicToPastTopics: (card) ->
    options = {value: pastTopicsList}
    trello.put "/1/cards/#{card.id}/idList", options, (error, data) ->
      if error
        console.log error
      console.log card # card object w id and name
      console.log data

  getCurrentTopic: ->
    # look in db
    return 'current topic'

module.exports = topics

# topics.selectTopic()

