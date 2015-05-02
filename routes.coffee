express = require 'express'
router = express.Router()

secrets = require './secrets'

# GET
router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Frog Bar'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip'
    thisWeek: ['hello', 'yolo', 'ribbbit']
    lastTopic: 'Duplo Times with LEGO'
    lastWeek: ['LEGOoOo', 'Bricks', 'Bloops']

router.get '/draw', (req, res, next) ->
  res.render 'draw',
    title: 'Frog Bar – draw'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' #

router.get '/debug', (req, res, next) ->
  # res.send secrets.trelloAPIKey

module.exports = router
