express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
uuid = require 'node-uuid'

config = require './config.json'
database = require './database'
palettes = require './palettes'
helpers = require './helpers'


router.get '/sign-up', (request, response, next) ->
  response.render 'sign-up',
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


#stub - ?needed?
# router.post '/sign-in', (request, response, next) ->
#   response.send request.body



#stub
# router.post '/save-drawing', (request, response, next) ->
  # request.body is #base 64 png img
  # https://developer.github.com/v3/repos/contents/#create-a-file
  # https://www.npmjs.com/package/github
  # create a new public repo

# stub/test
router.get '/sign-up-email-test', (request, response, next) ->
  response.render 'emails/sign-up'


# stub/test:
router.get '/unsubscribe', (request, response, next) ->
  response.send 'hello id: ' + request.query.signUpToken

router.get '/', (request, response, next) ->
  # temp: test with localhost:3000/?signUpToken=a8430a7a-5a67-4030-942a-977881bcc19f
  if request.query.signUpToken
    signUpToken = request.query.signUpToken
    database.addAccountToken(signUpToken)
  response.render 'draw',
    topic: 'Prarie Dogs on a Tea-Party Acid Trip' # stub
    lastTopic: 'Duplo Times with LEGO' # stub
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'} # stub - limit to 25 w random order?
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: false #stub
    # userName: userNameReturnFunction(if signedIn)

# router.post '/add-account-token', (request, response, next) ->
#   signUpToken = request.body.signUpToken
#   database.addAccountToken(signUpToken, response)

module.exports = router
