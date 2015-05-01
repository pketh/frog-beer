express = require 'express'
router = express.Router()

secrets = require './secrets'

# GET
router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Frog Bar'

router.get '/draw', (req, res, next) ->
  res.render 'draw',
    title: 'Frog Bar – draw'

router.get '/debug', (req, res, next) ->
  res.send secrets.trelloAPIKey

module.exports = router
