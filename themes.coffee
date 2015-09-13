# uses the trello board to pick a random theme
# sets currentTheme and lastTheme globally accessible vars

Trello = require 'node-trello'

config = require './config.json'
trello = new Trello(config.trello.key, config.trello.token)

# board = the board

themes =

  getTrelloAccountInfo: ->
    trello.get "/1/members/me", (error, data) ->
      console.log data

# getBoardInfo:
#
# selectTheme:
#   retrieve cards in list as array
#   shuffle the array
#   pick one

# lastTheme:



module.exports = themes

