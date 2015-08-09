express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
uuid = require 'node-uuid'

config = require './config.json'
database = require './database'
palettes = require './palettes'
helpers = require './helpers'


router.get '/sign-up-in', (request, response) ->
  response.render 'sign-up-in',
    palettes: null
    # drawings: req.cookies # in cookie if exists

router.post '/is-valid-email', (request, response) ->
  email = request.body.email
  response.send helpers.isEmail(email)

router.post '/new-sign-up', (request, response) ->
  email = helpers.validateEmail request
  nickname = helpers.validateName request
  signUpToken = uuid.v4()
  database.newSignUp(email, nickname, signUpToken, response)

#stub
# router.post '/save-drawing', (request, response) ->
  # accountCookie = request.cookies.accountToken
  # ?if accountCookie
  #   ?database.saveCookie
  # request.body is #base 64 png img
  # https://developer.github.com/v3/repos/contents/#create-a-file
  # https://www.npmjs.com/package/github
  # create a new public repo

# the link to this is in the email
# router.get '/unsubscribe-from-emails', (request, response) ->
#   response.send 'hello id: ' + request.query.signUpToken

# route.get '/sign-out' .. kills all accountTokens for an email account


router.post '/get-user-name', (request, response) ->
  accountToken = request.body.email
  database.getUserName(accountToken, response)

router.post '/add-account-token', (request, response) ->
  signUpToken = request.body.signUpToken
  database.addAccountToken(signUpToken, response)

router.get '/', (request, response) ->
  accountCookie = request.cookies.accountToken
  response.render 'draw',
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' # stub
    lastTopic: 'Duplo Times with LEGO' # stub
    lastWeek: {'path1':'user1', 'path2':'user2', 'path3':'user3'} # stub - limit to 25 w random order?
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: if accountCookie then true else false


module.exports = router
