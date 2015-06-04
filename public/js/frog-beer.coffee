# ?-> draw.coffee
# this file should be changed to be draw template specific
# update template, update build/cake tool

activePalette = []
pressingDown = false

selectColor = (context) ->
  color = $(context).css('background-color')
  highlightActivePaletteColor(context)

highlightActivePaletteColor = (context) ->
  $('.color').removeClass('active')
  $(context).addClass('active')

updatePalette = () ->
  for color, index in activePalette
    paletteContext = $('.palette-color')[index]
    $(paletteContext).css('background-color', color)
    if index is 0
      context = $('.palette-color')[0]
      selectColor(context)

newPalette = () ->
  shuffledPalettes = _.shuffle(palettes)
  for palette in shuffledPalettes
    if _.isEqual(activePalette, palette) is false
      activePalette = palette
      updatePalette()
      break

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

# remove check when renamed to draw.coffee
if palettes?
  newPalette()

$('.shuffle').click ->
  newPalette()

# drawing
$('.pixel').mousedown ->
  color = $('.color.active').css('background-color')
  pressingDown = true
  $(@).css("background-color", color)
$(document).mouseup ->
  pressingDown = false
$('.pixel').mousemove ->
  color = $('.color.active').css('background-color')
  if pressingDown
    $(@).css("background-color", color)
