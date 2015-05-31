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
    thisWeek: ['hello', 'yolo', 'ribbbit']
    lastTopic: 'Duplo Times with LEGO'
    lastWeek: ['LEGOoOo', 'Bricks', 'Bloops']
    palettes: null
    trello: config.trello
    github: config.github

router.get '/draw', (req, res, next) ->
  res.render 'draw',
    title: 'Frog Beer – draw'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip'
    palettes: Palettes

# router.get '/debug', (req, res, next) ->
#   # res.send config.trello.key
#   res.send trello: config.trello.board


# POSTs ..

module.exports = router
