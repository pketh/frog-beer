express = require 'express'
router = express.Router()
config = require './config.json'
palettes = require './palettes'

router.get '/', (request, response, next) ->
  response.render 'draw',
    title: 'Frog Beer'
    description: 'Draw cool things every week. 6% alcohol by volume. 4% frogs.'
    topic: 'Prarie Dogs on a Tea-Party Acid Trip'
    lastTopic: 'Duplo Times with LEGO'
    lastWeek: {'path1':'artist1', 'path2':'artist2', 'path3':'artist3'}
    palettes: palettes
    hasLoginToken: false
    trello: config.trello
    github: config.github

router.post '/save', (request, response, next) ->
  console.log request.body
  response.send '🎑 \n'

module.exports = router
