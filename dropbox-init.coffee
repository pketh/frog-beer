Dropbox = require 'dropbox'
config = require './config.json'

dropbox = new Dropbox.Client {token: config.dropbox}

module.exports = dropbox
