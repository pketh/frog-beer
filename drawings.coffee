async = require 'async'
fs = require 'fs'
uuid = require 'node-uuid'
moment = require 'moment'
colors = require 'colors'
mkdirp = require 'mkdirp'


config = require './config.json'
db = require './services/db'
dropbox = require './services/dropbox'
time = require './services/time'
s3 = require './services/s3'


drawings =

  saveDrawingToFileSystem: (path, filename, drawing, callback) ->
    file = "#{path}/#{filename}.png"
    mkdirp path, (error) ->
      if error
        console.log error
      fs.writeFile file, drawing, (error) ->
        if error
          console.log error
        console.log "#{filename}.png saved".green
        callback null

  saveDrawingToS3: (path, filename, callback) ->
    file = "#{time.currentWeek}/#{filename}.png"
    params =
      localFile: "#{path}/#{filename}.png"
      s3Params:
        Bucket: "frog-beer"
        Key: file
        ACL: "public-read"
        ContentType: "image/png"
    upload = s3.uploadFile params
    upload.on 'error', (error) ->
      console.log error
    upload.on 'end', ->
      console.log "Uploaded to S3".green
      callback null

  saveDrawingInfoToDB: (accountCookie, path, callback) ->
    db.Users.findOne
      accountTokens: accountCookie
    ,
    (error, user) ->
      if error
        console.log error
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
        console.log "image info saved to db".green

  saveDrawing: (drawing, accountCookie, response) ->
    filename = "#{uuid.v4()}"
    path = "./public/blobs/#{time.currentWeek}"
    async.series [
      async.apply drawings.saveDrawingToFileSystem, path, filename, drawing
      async.apply drawings.saveDrawingToS3, path, filename
    ], ->
      drawings.saveDrawingInfoToDB accountCookie, path
      response.send true

# .......
  saveAnonymousDrawing: ->
    filename = "#{uuid.v4()}"
    path = "./public/blobs/anonymous/#{filename}.png"
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
