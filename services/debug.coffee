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


  # ! DRAWINGS output this on mainpage
  # getDrawingsInCurrentWeek: ->
  #   dropbox.readdir "/#{time.currentWeek}", (error, drawings) ->
  #     if error
  #       console.log error
  #     else
  #       for drawing in drawings
  #         console.log drawing
        # define drawing = entry.data or whatever for the image
        # for each file in files
          # drawings.getDrawing(drawing) .. do a callback
            # on the call back, do ..
            # drawingscurrentWeek.push(returned img) to an array of image data
            ##  will need to serialize/deserialize image data blob <-> ascii

  # ! output this on weekly email
  # getDrawingsInLastWeek: ->
  #   dropbox.makeUrl "/#{time.lastWeek}", {downloadHack: true}, (error, drawings) ->
  #     if error
  #       console.log error
  #     else
  #       console.log "DRAWINGS IN LAST WEEK".yellow
  #       console.log drawings
  #       return drawings
        # do things like above..
        # returns array of paths

