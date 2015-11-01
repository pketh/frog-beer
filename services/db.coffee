mongojs = require 'mongojs'

config = require '../config.json'

[Users, Drawings, Topics] = [null]

GLOBAL.mongoURL = "mongodb://#{config.mongo.user}:#{config.mongo.password}@#{config.mongo.path}"
console.log "mongo #{config.mongo.path} -u #{config.mongo.user} -p #{config.mongo.password}".magenta

database = mongojs GLOBAL.mongoURL, [],
  authMechanism : 'ScramSHA1'

database.createCollection 'Users', {}
database.createCollection 'Drawings', {}
database.createCollection 'Topics', {}
database.createCollection 'Agenda', {}

db =

  Users: database.collection 'Users'
  Drawings: database.collection 'Drawings'
  Topics: database.collection 'Topics'

module.exports = db
