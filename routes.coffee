express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
# validator = require 'validator'
uuid = require 'node-uuid'

config = require './config.json'
database = require './database'
palettes = require './palettes'
helpers = require './helpers'


# stub
# this is where the emailed token link goes to for verification/welcome
router.get '/hello', (request, response, next) ->
  response.send 'hello'

router.get '/', (request, response, next) ->
  response.render 'draw',
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' # stub
    lastTopic: 'Duplo Times with LEGO' # stub
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'} # stub
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: false #stub
    # userName: userNameReturnFunction(if signedIn)

router.get '/sign-up', (request, response, next) ->
  response.render 'sign-up',
    palettes: null
    # drawings: req.cookies # in cookie if exists

router.post '/new-sign-up', (request, response, next) ->
  email = helpers.validateEmail request
  nickname = helpers.validateName request
  signUpToken = uuid.v4()
  response.send {email, nickname, signUpToken}
  # database.newSignUp(email, nickname, signUpToken)

router.post '/is-valid-email', (request, response, next) ->
  email = request.body.email
  response.send helpers.isEmail(email)

#stub
router.post '/sign-in', (request, response, next) ->
  response.send request.body

#stub
router.post '/save-drawing', (request, response, next) ->
  response.send request.body #base 64 img


module.exports = router
