uuid = require 'node-uuid' ##temp
moment = require 'moment'

config = require './config.json'
db = require './services/db'
dropbox = require './services/dropbox'
time = require './services/time'

drawings =

  getDrawingsInCurrentWeek: ->
    dropbox.readdir "/#{time.currentWeek}", (error, drawings) ->
      if error
        console.log error
      else
        for drawing in drawings
          console.log drawing
        # define drawing = entry.data or whatever for the image
        # for each file in files
          # drawings.getDrawing(drawing) .. do a callback
            # on the call back, do ..
            # drawingscurrentWeek.push(returned img) to an array of image data
            ##  will need to serialize/deserialize image data blob <-> ascii

  getDrawingsInLastWeek: ->
    dropbox.makeUrl "/#{time.lastWeek}", {downloadHack: true}, (error, drawings) ->
      if error
        console.log error
      else
        console.log drawings
        return drawings
        # do things like above..
        # returns array of paths

  getDrawing: (path) ->
    dropbox.readFile path, (error, data) ->
      if error
        console.log error
      console.log "#{path} retrieved"
      console.log data
      # return response or true

  extractColor: () ->
    console.log 'return bk color'

  saveDrawingInfoToDB: (accountCookie, path, response) ->
    db.Users.findOne
      accountTokens: accountCookie
    ,
    (error, user) ->
      if error
        console.log error
      else
        console.log user
        db.Drawings.insert
            created: moment.utc()
            path: path
            week: time.week
            name: user.name
            userId: user._id
            email: user.email
        ,
        (error, document) ->
          if error
            console.log error
          else
            console.log "image info saved to db"
            console.log document
            response.send true


  saveDrawing: (drawing, accountCookie, response) ->
    filename = "#{uuid.v4()}"
    console.log drawing
    path = "#{time.currentWeek}/#{filename}.png"
    dropbox.writeFile path, drawing, (error, stat) ->
      if error
        console.log error
      else
        console.log "#{stat.name} saved to: #{stat.path}"
        # get dropbox file
          # call getSampleColor(drawing)
        drawings.saveDrawingInfoToDB(accountCookie, path, response)

  saveAnonymousDrawing: ->
    filename = "#{uuid.v4()}"
    path = "anonymous/#{filename}.png"
    console.log filename
    console.log dropbox
    dropbox.writeFile path, drawing, (error, stat) ->
      console.log stat
      if error
        console.log error
      else
# .............insert db add anon drawing info to db ..
        console.log "ANON DRAWING: #{stat.name} saved to: #{stat.path}"
        response.send true
      # also mail me personally re: each new submission - sendModerationMail

module.exports = drawings
