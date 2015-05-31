highlightActiveColor = (context) ->
  $('.color').removeClass('active')
  $(context).addClass('active')

updateCursor = (color) ->
  # ?? client style cursor?

updateColor = (color) ->
  # drawing color is this

$('.color').not('.shuffle').click ->
  color = $(@).data('color')
  context = @
  highlightActiveColor(context)
  updateCursor(color)
  updateColor(color)


$('.shuffle').click ->
  # console.log 'shuffle colors..'


# register key clicks to select colors



# tasks: route randomly sends an object of color arrays,
# load random colorset to pallette
# clicking shuffle loads a new array
