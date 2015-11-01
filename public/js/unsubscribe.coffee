EMAIL_UNSUBSCRIBE_INPUT = $('.unsubscribe-form input[name="email"]')

showUnsubscribeSuccess = (nickname) ->
  $('.unsubscribe').addClass('hidden')
  $('.unsubscribe-success').removeClass('hidden')

showUnsubscribeError = ->
  EMAIL_UNSUBSCRIBE_INPUT.addClass 'error'

clearError = ->
  EMAIL_UNSUBSCRIBE_INPUT.removeClass 'error'

submitUnsubscribeForm = (email) ->
  $.ajax
    url: '/unsubscribe'
    type: 'POST'
    data:
      'email': email
    success: (response) ->
      showUnsubscribeSuccess()
    error: (response) ->
      showUnsubscribeError()

$('.unsubscribe-form').submit (event) ->
  event.preventDefault()
  email = EMAIL_UNSUBSCRIBE_INPUT.val().trim()
  if email
    $.ajax
      url: '/is-valid-email'
      type: 'POST'
      data:
        'email': email
      success: (isValidEmail) ->
        if isValidEmail
          clearError()
          submitUnsubscribeForm email
        else
          showUnsubscribeError()
  else
    showUnsubscribeError()
