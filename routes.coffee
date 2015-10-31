express = require 'express'
router = express.Router()
cookieParser = require 'cookie-parser'
uuid = require 'node-uuid'
colors = require 'colors'
_ = require 'underscore'

config = require './config.json'
users = require './users'
palettes = require './palettes'
drawings = require './drawings'
helpers = require './helpers'


router.post '/is-valid-email', (request, response) ->
  email = request.body.email
  response.send helpers.isEmail(email)

router.post '/new-sign-up', (request, response) ->
  email = helpers.validateEmail request
  nickname = helpers.validateName request
  signUpToken = uuid.v4()
  users.signUp(email, nickname, signUpToken, response)

router.post '/save-drawing', (request, response) ->
  accountCookie = request.cookies.accountToken
  drawing = request.body.image
  drawing = drawing.substring drawing.indexOf('base64,')+7
  drawingBuffer = new Buffer(drawing, 'base64')
  if accountCookie
    drawings.saveDrawing(drawingBuffer, accountCookie, response)
  else
    drawings.saveAnonymousDrawing(drawingBuffer, response)


# the link to this is in the email
# router.get '/unsubscribe-from-emails', (request, response) ->
  # flip a db bool for unsubscribed: true
  # don't send emails to ppl with unsubscribed: true
    # res render emails/unsubscribed.jade
    # please enter your email to unsubscribe
    # (シ_ _)シ
    # (sorry about the extra step, I'm just lazy)
#   response.send 'hello id: ' + request.query.signUpToken


# router.get '/unsubscribed-from-emails', (request, response) ->
# (res render emails/unsubscribed.jade)
# You're now unsubscribed. I still love you.
# (╯°□°）╯︵ ┻━┻

# new topics happen every week, you can still visit and draw things
# if you want to start getting weekly emails again, just let me know at hi@pketh.org and we'll be all chummy again.
# ┬──┬◡ﾉ(° -°ﾉ)


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

router.post '/get-user-name', (request, response) ->
  accountToken = request.body.email
  users.getUserName(accountToken, response)

router.post '/add-account-token', (request, response) ->
  signUpToken = request.body.signUpToken
  users.addAccountToken(signUpToken, response)

router.get '/', (request, response) ->
  accountCookie = request.cookies.accountToken
  drawingsInLastWeek = _.sample GLOBAL.drawingsInLastWeek, 25
  response.render 'draw',
    topic: GLOBAL.currentTopic
    lastTopic: GLOBAL.previousTopic
    drawingsInLastWeek: drawingsInLastWeek
    palettes: palettes
    trello: config.trello
    github: config.github
    contentPage: true
    isSignedIn: if accountCookie then true else false


module.exports = router
