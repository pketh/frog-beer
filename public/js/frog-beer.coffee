selectColor = (context) ->
  color = $(context).data('color')
  highlightActiveColor(context)
  updateCursor(color)

highlightActiveColor = (context) ->
  $('.color').removeClass('active')
  $(context).addClass('active')

updateCursor = (color) ->
  # changes the active draw color

# get random palette
# update palette (grid and palette)

# getColors - randomly pick an array, make it local, make sure the new colors aren't the same as the old colors

activePalette = []
getPalette = () ->
  shuffledPalettes = _.shuffle(palettes)
  for palette in shuffledPalettes
    if _.isEqual(activePalette, palette) is false
      activePalette = palette
      break

updatePalette = () ->
  for color, index in activePalette
    paletteColor = $('.palette-color')[index]
    console.log paletteColor
    $(paletteColor).css('background-color', color)
  firstColor = $('.palette-color')[0]
  selectColor(firstColor)

newPalette = () ->
  getPalette()
  updatePalette()
  # updateDrawing


  # // var chosen_team = teams.random(teams.length)


# updateColors - new palette chosen means update to pallete and grid art pixels


$('.color').not('.shuffle').click ->
  context = @
  selectColor(context)

$(document).keypress (key) ->
  if key.which is 49
    context = $('.color')[0]
    selectColor(context)
  else if key.which is 50
    context = $('.color')[1]
    selectColor(context)
  else if key.which is 51
    context = $('.color')[2]
    selectColor(context)
  else if key.which is 52
    context = $('.color')[3]
    selectColor(context)
  else if key.which is 53
    context = $('.color')[4]
    selectColor(context)
  else if key.which is 54
    context = $('.color')[5]
    selectColor(context)


$('.shuffle').click ->
  newPalette()
  # console.log 'shuffle colors..'

if palettes?
  newPalette()
