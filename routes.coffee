express = require 'express'
router = express.Router()
config = require './config.json'
palettes = require './palettes'
cookieParser = require 'cookie-parser'


# GET #

router.get '/hello', (request, response, next) ->
  response.render 'hello',
    palettes: null
    # art: req.cookies # in cookie if exists

router.get '/', (request, response, next) ->
  response.render 'draw',
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' # stub
    lastTopic: 'Duplo Times with LEGO' # stub
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'} # stub
    palettes: palettes
    hasLoginToken: false
    trello: config.trello
    github: config.github
    contentPage: true


# POST #

router.post '/save', (request, response, next) ->
  console.log request.body
  response.send '🎑 \n'

router.post '/sign-up', (request, response, next) ->
  response.send 'sign up stub'

module.exports = router
