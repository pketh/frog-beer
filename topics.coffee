# uses the trello board to pick a random theme
# sets currentTheme and lastTheme globally accessible vars

Trello = require 'node-trello'

config = require './config.json'
trello = new Trello(config.trello.key, config.trello.token)

# board = the board
board = '55458e45bbd7364c39f36b54'
upcomingList = '55458e8002d6d526cff3ff10'

topics =

  getTrelloAccountInfo: ->
    trello.get "/1/members/me", (error, data) ->
      console.log data

  getBoardInfo: ->
    trello.get "/1/boards/#{board}", (error, data) ->
      console.log "info for board: #{data.name}"
      console.log data

  getLists: ->
    listOptions = {lists: 'open', list_fields: 'name'}
    trello.get "/1/boards/#{board}", listOptions, (error, data) ->
      console.log "info for board: #{data.name}"
      console.log data


  # selectTheme: ->



# selectTheme:
#   retrieve cards in list as array
#   shuffle the array
#   pick one
# lastTheme:


module.exports = topics

topics.getLists()