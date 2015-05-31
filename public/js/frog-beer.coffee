console.log colorsets


updateColor = (context) ->
  color = $(context).data('color')
  highlightActiveColor(context)
  # updateCursor(color)

highlightActiveColor = (context) ->
  $('.color').removeClass('active')
  $(context).addClass('active')

# updateCursor = (color) ->
  # ?? client style cursor?


$('.color').not('.shuffle').click ->
  context = @
  updateColor(context)

$(document).keypress (key) ->
  if key.which is 49
    context = $('.color')[0]
    updateColor(context)
  else if key.which is 50
    context = $('.color')[1]
    updateColor(context)
  else if key.which is 51
    context = $('.color')[2]
    updateColor(context)
  else if key.which is 52
    context = $('.color')[3]
    updateColor(context)
  else if key.which is 53
    context = $('.color')[4]
    updateColor(context)
  else if key.which is 54
    context = $('.color')[5]
    updateColor(context)


$('.shuffle').click ->
  # console.log 'shuffle colors..'


# register key clicks to select colors



# tasks: route randomly sends an object of color arrays,
# load random colorset to pallette
# clicking shuffle loads a new array
