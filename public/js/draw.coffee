activePalette = []
currentPalette = 0
pressingDown = false
pixels = []
PIXEL_SIZE = 20
CANVAS_SIZE = 400

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
  totalPalettes = palettes.length - 1
  if currentPalette > totalPalettes
    currentPalette = 0
  activePalette = palettes[currentPalette]
  updatePalette()
  currentPalette = currentPalette + 1

newPalette()

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
  else if key.which is 55
    $('.shuffle').trigger('click')

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

#saving
getPixels = () ->
  drawing = $('.drawing .pixel')
  pixels = []
  for pixel in drawing
    pixelColor = $(pixel).css('background-color')
    pixels.push(pixelColor)

paintCanvasRow = (pixelColor, index, row) ->
    X = PIXEL_SIZE * index - (CANVAS_SIZE * row)
    Y = PIXEL_SIZE * row
    canvas = document.getElementById("canvas")
    context = canvas.getContext '2d'
    context.fillStyle = pixelColor
    context.fillRect(X, Y, PIXEL_SIZE, PIXEL_SIZE)


drawPixelsOnCanvas = (pixels) ->
  for pixelColor, index in pixels
    if index < 20
      paintCanvasRow(pixelColor, index, 0)
    if index < 40
      paintCanvasRow(pixelColor, index, 1)
    if index < 60
      paintCanvasRow(pixelColor, index, 2)
    if index < 80
      paintCanvasRow(pixelColor, index, 3)
    if index < 100
      paintCanvasRow(pixelColor, index, 4)
    if index < 120
      paintCanvasRow(pixelColor, index, 5)
    if index < 140
      paintCanvasRow(pixelColor, index, 6)
    if index < 160
      paintCanvasRow(pixelColor, index, 7)
    if index < 180
      paintCanvasRow(pixelColor, index, 8)
    if index < 200
      paintCanvasRow(pixelColor, index, 9)
    if index < 220
      paintCanvasRow(pixelColor, index, 10)
    if index < 240
      paintCanvasRow(pixelColor, index, 11)
    if index < 260
      paintCanvasRow(pixelColor, index, 12)
    if index < 280
      paintCanvasRow(pixelColor, index, 13)
    if index < 300
      paintCanvasRow(pixelColor, index, 14)
    if index < 320
      paintCanvasRow(pixelColor, index, 15)
    if index < 340
      paintCanvasRow(pixelColor, index, 16)
    if index < 360
      paintCanvasRow(pixelColor, index, 17)
    if index < 380
      paintCanvasRow(pixelColor, index, 18)
    if index < 400
      paintCanvasRow(pixelColor, index, 19)

saveCanvas = () ->
  canvas = document.getElementById("canvas")
  drawing = canvas.toDataURL("image/png")
  $.post '/save-drawing', {'image': drawing, 'week': 0, 'userID': 'yr32saf32'}, (response) ->
    console.log response
    if response.code == 202
      console.log response
      $('.save-drawing').hide()
      $('.anonymous-drawing-saved').show()
      $('.palette').hide()
      $('.drawing').hide()
      $('#canvas').show()
      Cookies.set 'drawing', response.drawing
      console.log Cookies.get 'drawing'
      # set a coopkie, w response.file, append to it
      # save anon actions = save a cookie w the response object, id type of
    else
      console.log response
      $('.save-drawing').hide()
      $('.drawing-saved').show()
      $('.palette').hide()
      $('.drawing').hide()
      $('#canvas').show()

$('.save-button').click ->
  getPixels()
  drawPixelsOnCanvas(pixels)
  saveCanvas()

clearCanvas = () ->
  canvas = document.getElementById("canvas")
  context = canvas.getContext '2d'
  context.clearRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);
  $('.pixel').css('background-color', '')

$('.draw-another').click ->
  clearCanvas()
  $('.save-drawing').show()
  $('.drawing-saved').hide()
  $('.anonymous-drawing-saved').hide()
  $('.palette').show()
  $('.drawing').show()
  $('#canvas').hide()
