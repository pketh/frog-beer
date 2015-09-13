Dropbox = require 'dropbox'
moment = require 'moment'
uuid = require 'node-uuid' ##temp

config = require './config.json'
themes = require './themes'
dropbox = new Dropbox.Client {token: config.dropbox}

year = moment().year()
week = moment().week()
currentWeek = "#{year}-#{week}"
lastWeek = "#{year}-#{week - 1}"

drawingsInCurrentWeek = []

drawings =

  getDropboxAccountInfo: ->
    dropbox.getAccountInfo (error, accountInfo) ->
      console.log accountInfo


  # triggered on a schedule cron, or accompanying email send (decentralized or centralized)
  createcurrentWeekPath: ->
    dropbox.createDir currentWeek, (error, response, body) ->
      console.log body

  recordcurrentWeekTheme: ->
    # get the thing that picks trello picker
      # // dropbox: inside this weeks path, create a text file with theme .txt and contents with moment.today \n theme
      dropbox.writeFile "#{currentWeek}/theme-#{theme}.txt", theme, (error, data) ->
        if error
          return showError error
        console.log "theme set as #{theme}"
        console.log data

  getDrawingsInCurrentWeek: ->
    dropbox.readdir "/#{currentWeek}", (error, entries) ->
      if error
        return showError error
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
        return showError error
      for entry in entries
        console.log entry
        # do things like above..

  getDrawing: (path) ->
    dropbox.readFile path, (error, data) ->
      if error
        return showError error
      console.log "#{path} retrieved"
      console.log data
      # return response or true

  #
  saveDrawing: (drawing, response) ->
    # console.log drawing
    filename = "#{uuid.v4()}"
    # username + get number of uploaded images + 1
    # ?filename in format like Bob1.png, Bob2.png, Bob3.png
    # anonified to not rely on username: 1.png , 2.png, 3...
    path = "#{currentWeek}/#{filename}.png"
    # drawing = drawing.replace(/^data:image\/\w+;base64,/, "")
    # drawing = drawing.replace(/ /g, '+')
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        return showError error
      console.log "#{stat.name} saved to: #{stat.path}"
      console.log stat
      response.send true


  saveAnonymousDrawing: ->
    filename = "#{uuid.v4()}"
    path = "anonymous/#{filename}.png"
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        return showError error
    console.log "#{stat.name} saved to: #{stat.path}"


    # temp - random name , associated w user cookie

module.exports = drawings

#
# drawings.getDropboxAccountInfo()
