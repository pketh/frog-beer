express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
uuid = require 'node-uuid'

config = require './config.json'
users = require './users'
palettes = require './palettes'
drawings = require './drawings'
# topics = require './topics'
helpers = require './helpers'


router.post '/is-valid-email', (request, response) ->
  email = request.body.email
  response.send helpers.isEmail(email)

router.post '/new-sign-up', (request, response) ->
  email = helpers.validateEmail request
  nickname = helpers.validateName request
  signUpToken = uuid.v4()
  users.signUp(email, nickname, signUpToken, response)

#🔮
router.post '/save-drawing', (request, response) ->
  accountCookie = request.cookies.accountToken
  # console.log accountCookie
  drawing = request.body.image
  drawing = drawing.substring drawing.indexOf('base64,')+7
  # console.log drawing
  drawingBuffer = new Buffer(drawing, 'base64')
  # console.log drawingBuffer
  if accountCookie
    console.log 'save acct'
    drawings.saveDrawing(drawingBuffer, accountCookie, response)
  else
    console.log 'save anon'
    drawings.saveAnonymousDrawing(drawingBuffer, response)


  # ?users.saveCookie
      # also mail me personally re: each new submission
  # request.body is #base 64 png img


# the link to this is in the email
# router.get '/unsubscribe-from-emails', (request, response) ->
#   response.send 'hello id: ' + request.query.signUpToken

router.get '/sign-up-in', (request, response) ->
  response.render 'sign-up-in',
    palettes: null
    signUpInPage: true
    # drawings: req.cookies # in cookie if exists

router.get '/sign-out', (request, response) ->
  accountToken = request.cookies.accountToken
  console.log accountToken
  users.clearAccountTokens(accountToken)
  response.render 'sign-out',
    palettes: null
    signOutPage: true
  #.. kills all accountTokens for an email account


router.post '/get-user-name', (request, response) ->
  accountToken = request.body.email
  users.getUserName(accountToken, response)

router.post '/add-account-token', (request, response) ->
  signUpToken = request.body.signUpToken
  users.addAccountToken(signUpToken, response)

router.get '/', (request, response) ->
  accountCookie = request.cookies.accountToken
  response.render 'draw',
    topic: 'Amurica!' # stub
    lastTopic: 'The Haunting' # stub
    lastWeek: {'path1':'user1', 'path2':'user2', 'path3':'user3'} # stub - limit to 25 w random order?
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: if accountCookie then true else false


module.exports = router
