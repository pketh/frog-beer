async = require 'async'
fs = require 'fs'
uuid = require 'node-uuid'
moment = require 'moment'
colors = require 'colors'
mkdirp = require 'mkdirp'
_ = require 'underscore'

config = require './config.json'
db = require './services/db'
time = require './services/time'
s3 = require './services/s3'


drawings =

  updateDrawingsInLastWeek: (callback) ->
    lastweek = time.week - 1
    db.Drawings.find {week: lastweek}, {url: true, _id:false}, (error, drawings) ->
      if error
        console.log error
      GLOBAL.drawingsInLastWeek = _.pluck(drawings, 'url')
      callback null

  saveDrawingLocally: (path, file, drawing, callback) ->
    localPath = "#{path}/#{file}"
    mkdirp path, (error) ->
      if error
        console.log error
      fs.writeFile localPath, drawing, (error) ->
        if error
          console.log error
        console.log "#{file} saved".green
        callback null

  saveDrawingToS3: (path, file, remotePath, callback) ->
    params =
      localFile: "#{path}/#{file}"
      s3Params:
        Bucket: "frog-beer"
        Key: remotePath
        ACL: "public-read"
        ContentType: "image/png"
    upload = s3.uploadFile params
    upload.on 'error', (error) ->
      console.log error
    upload.on 'end', ->
      console.log "Uploaded to S3".green
      callback null

  saveDrawingInfoToDB: (accountCookie, remotePath, callback) ->
    db.Users.findOne
      accountTokens: accountCookie
    ,
    (error, user) ->
      if error
        console.log error
      db.Drawings.insert
        created: moment.utc().format('MMMM Do YYYY, h:mm:ss a')
        url: "#{config.s3.bucketPath}/#{remotePath}"
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
    console.log "Saving user drawing".cyan
    file = "#{uuid.v4()}.png"
    path = "./public/blobs/#{time.currentWeek}"
    remotePath = "#{time.currentWeek}/#{file}"
    async.series [
      async.apply drawings.saveDrawingLocally, path, file, drawing
      async.apply drawings.saveDrawingToS3, path, file, remotePath
      async.apply drawings.updateDrawingsInLastWeek
    ], ->
      drawings.saveDrawingInfoToDB accountCookie, remotePath
      response.sendStatus 200

  saveAnonymousDrawing: (drawing, response) ->
    console.log "Saving anonymous drawing".cyan
    name = uuid.v4()
    file = "#{name}.png"
    path = "./public/blobs/anonymous/#{file}"
    remotePath = "anonymous/#{file}"
    async.series [
      async.apply drawings.saveDrawingLocally, path, file, drawing
      async.apply drawings.saveDrawingToS3, path, file, remotePath
    ], ->
      response.send
        code: 202
        drawing: name

  moveDrawingToWeek: (name, accountCookie, response) ->
    file = "#{name}.png"
    anonymousRemotePath = "anonymous/#{file}"
    remotePath = "#{time.currentWeek}/#{file}"
    s3Params =
      Bucket: "frog-beer"
      CopySource: "frog-beer/" + anonymousRemotePath
      Key: remotePath
      ACL: "public-read"
    move = s3.moveObject s3Params
    move.on 'error', (error) ->
      console.log error
    move.on 'end', ->
      console.log "File moved in S3".green
      drawings.saveDrawingInfoToDB accountCookie, remotePath
      response.sendStatus 200

module.exports = drawings
