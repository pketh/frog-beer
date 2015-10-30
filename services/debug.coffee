# Trello = require 'node-trello'
# board = '55458e45bbd7364c39f36b54'
# upcomingTopicsList = '55458e8002d6d526cff3ff10'
# pastTopicsList = '55458ea267f62bfd5cb3fb13'

# getTrelloAccountInfo: ->
  #   trello.get "/1/members/me", (error, data) ->
  #     if error
  #       console.log error
  #     console.log data

  # getBoardInfo: ->
  #   trello.get "/1/boards/#{board}", (error, data) ->
  #     if error
  #       console.log error
  #     console.log "info for board: #{data.name}:"
  #     console.log data

  # getLists: ->
  #   options = {lists: 'open', list_fields: 'name'}
  #   trello.get "/1/boards/#{board}", options, (error, data) ->
  #     if error
  #       console.log error
  #     console.log data
