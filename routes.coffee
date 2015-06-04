express = require 'express'
router = express.Router()
store = require './store'
config = require './config.json'

Palettes = require './palettes'

# GET
router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Frog Beer'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip'
    lastTopic: 'Duplo Times with LEGO'
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'}
    palettes: Palettes
    artistIsIn: false
    trello: config.trello
    github: config.github

# router.get '/debug', (req, res, next) ->
#   # res.send config.trello.key
#   res.send trello: config.trello.board


# POSTs ..

module.exports = router
