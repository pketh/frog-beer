uuid = require 'node-uuid' ##temp

config = require './config.json'
dropbox = require './dropbox-init'
time = require './time'

drawings =

  # triggered on a schedule cron, or accompanying email send (decentralized or centralized)
  # createCurrentWeekPath: ->
  #   dropbox.createDir time.currentWeek, (error, response, body) ->
  #     console.log body

  getDrawingsInCurrentWeek: ->
    dropbox.readdir "/#{time.currentWeek}", (error, entries) ->
      if error
        console.log error
      for entry in entries
        console.log entry
        # define drawing = entry.data or whatever for the image
        # for each file in files
          # drawings.getDrawing(drawing) .. do a callback
            # on the call back, do ..
            # drawingscurrentWeek.push(returned img) to an array of image data
            ##  will need to serialize/deserialize image data blob <-> ascii

  getDrawingsInLastWeek: ->
    dropbox.readdir "/#{lastWeek}", (error, entries) ->
      if error
        console.log error
      for entry in entries
        console.log entry
        # do things like above..

  getDrawing: (path) ->
    dropbox.readFile path, (error, data) ->
      if error
        console.log error
      console.log "#{path} retrieved"
      console.log data
      # return response or true


  saveDrawing: (drawing, accountCookie, response) ->
    filename = "#{uuid.v4()}"
    path = "#{time.currentWeek}/#{filename}.png"
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        console.log error
      else
        console.log "#{stat.name} saved to: #{stat.path}"
        console.log stat
        # get username from accountcookie token
        response.send true
        # also mail me personally re: each new submission (reponse)

  saveAnonymousDrawing: ->
    filename = "#{uuid.v4()}"
    path = "anonymous/#{filename}.png"
    console.log filename
    console.log dropbox
    dropbox.writeFile path, drawing, (error, stat) ->
      console.log stat
      if error
        console.log error
      console.log "ANON DRAWING: #{stat.name} saved to: #{stat.path}"
      response.send true
      # also mail me personally re: each new submission

module.exports = drawings
