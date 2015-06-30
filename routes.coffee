express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
validator = require 'validator'
uuid = require 'node-uuid'

config = require './config.json'
palettes = require './palettes'
utils = require './utils'

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

#stub
router.post '/save-drawing', (request, response, next) ->
  response.send request.body #base 64 img

router.post '/is-valid-email', (request, response, next) ->
  isValidEmail = validator.isEmail request.body.email
  response.send isValidEmail

router.post '/sign-up', (request, response, next) ->
  email = utils.validateEmail request
  name = utils.validateName request
  signUpToken = uuid.v4()

  response.send request.body
  # send an email with the verification token

#stub
router.post '/sign-in', (request, response, next) ->
  response.send request.body


module.exports = router
