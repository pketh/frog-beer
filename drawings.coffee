Dropbox = require 'dropbox'
moment = require 'moment'
uuid = require 'node-uuid' ##temp

config = require './config.json'
dropbox = new Dropbox.Client {token: config.dropbox}

year = moment().year()
week = moment().week()
currentWeek = "#{year}-#{week}"
lastWeek = "#{year}-#{week - 1}"

drawings =

  getDropboxAccountInfo: ->
    dropbox.getAccountInfo (error, accountInfo) ->
      console.log accountInfo

  # triggered on a schedule cron, or accompanying email send (decentralized or centralized)
  createCurrentWeekPath: ->
    dropbox.createDir currentWeek, (error, response, body) ->
      console.log body

  recordCurrentWeekTopic: ->
    dropbox.writeFile "#{currentWeek}/topic-#{topic}.txt", topic, (error, data) ->
      if error
        console.log error
      database.addNewTopic(topic)
      console.log "topic set as #{topic}"
      console.log data

  getCurrentTopic: ->
    return currentWeek

  getDrawingsInCurrentWeek: ->
    dropbox.readdir "/#{currentWeek}", (error, entries) ->
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

  #
  saveDrawing: (drawing, response) ->
    filename = "#{uuid.v4()}"
    # username + get number of uploaded images + 1
    # ?filename in format like Bob1.png, Bob2.png, Bob3.png
    # anonified to not rely on username: 1.png , 2.png, 3...
    path = "#{currentWeek}/#{filename}.png"
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        console.log error
      console.log "#{stat.name} saved to: #{stat.path}"
      console.log stat
      response.send true


  saveAnonymousDrawing: ->
    filename = "#{uuid.v4()}"
    path = "anonymous/#{filename}.png"
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        console.log error
    console.log "#{stat.name} saved to: #{stat.path}"


module.exports = drawings

# drawings.getDropboxAccountInfo()
