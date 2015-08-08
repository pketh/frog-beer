express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
uuid = require 'node-uuid'

config = require './config.json'
database = require './database'
palettes = require './palettes'
helpers = require './helpers'


router.get '/sign-up-in', (request, response, next) ->
  response.render 'sign-up-in',
    palettes: null
    # drawings: req.cookies # in cookie if exists

router.post '/is-valid-email', (request, response, next) ->
  email = request.body.email
  response.send helpers.isEmail(email)

router.post '/new-sign-up', (request, response, next) ->
  email = helpers.validateEmail request
  nickname = helpers.validateName request
  signUpToken = uuid.v4()
  database.newSignUp(email, nickname, signUpToken, response)


#stub
# router.post '/save-drawing', (request, response, next) ->
  # request.body is #base 64 png img
  # https://developer.github.com/v3/repos/contents/#create-a-file
  # https://www.npmjs.com/package/github
  # create a new public repo


# stub/test:
# router.get '/unsubscribe-from-emails', (request, response, next) ->
#   response.send 'hello id: ' + request.query.signUpToken

# stub:
# route.get '/sign-out' .. kills all accountTokens for an email account

router.get '/', (request, response, next) ->
  response.render 'draw',
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' # stub
    lastTopic: 'Duplo Times with LEGO' # stub
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'} # stub - limit to 25 w random order?
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: false #stub


router.post '/add-account-token', (request, response, next) ->
  signUpToken = request.body.signUpToken
  console.log signUpToken
  database.addAccountToken(signUpToken, response)

module.exports = router
