express = require 'express'
router = express.Router()

# GET
router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Frog Bar'

router.get '/draw', (req, res, next) ->
  res.render 'draw',
    title: 'Frog Bar – draw'

module.exports = router
