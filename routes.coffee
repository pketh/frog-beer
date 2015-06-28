express = require 'express'
router = express.Router()
config = require './config.json'
palettes = require './palettes'
cookieParser = require 'cookie-parser'
validator = require 'validator'

# GET #

router.get '/sign-up', (request, response, next) ->
  response.render 'sign-up',
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
  response.send 'image received'

router.post '/is-valid-email', (request, response, next) ->
  console.log request.body
  isValidEmail = validator.isEmail request.body.email
  console.log isValidEmail
  response.send isValidEmail

router.post '/sign-up', (request, response, next) ->
  console.log request.body
  isValidEmail = validator.isEmail request.body

router.post '/sign-in', (request, response, next) ->
  console.log request.body
  isValidEmail = validator.isEmail request.body


module.exports = router
