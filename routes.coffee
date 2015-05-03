express = require 'express'
router = express.Router()

config = require './config.json'
# store = require './store' # do this after setting up the export

# GET
router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Frog Beer'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip'
    thisWeek: ['hello', 'yolo', 'ribbbit']
    lastTopic: 'Duplo Times with LEGO'
    lastWeek: ['LEGOoOo', 'Bricks', 'Bloops']
    trello: config.trello
    github: config.github

router.get '/draw', (req, res, next) ->
  res.render 'draw',
    title: 'Frog Beer – draw'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' #

router.get '/debug', (req, res, next) ->
  # res.send config.trello.key
  res.send trello: config.trello.board


# POST

module.exports = router
