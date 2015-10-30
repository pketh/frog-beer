sync = require 'sync'
mongojs = require 'mongojs'

config = require '../config.json'

[Users, Drawings, Topics] = [null]

path = "mongodb://#{config.mongo.user}:#{config.mongo.password}@#{config.mongo.path}"
console.log "mongo #{config.mongo.path} -u #{config.mongo.user} -p #{config.mongo.password}".magenta

database = mongojs path, [],
  authMechanism : 'ScramSHA1'

sync ->
  database.createCollection 'Users', {}
  database.createCollection 'Drawings', {}
  database.createCollection 'Topics', {}

db =

  Users: database.collection 'Users'
  Drawings: database.collection 'Drawings'
  Topics: database.collection 'Topics'

module.exports = db
