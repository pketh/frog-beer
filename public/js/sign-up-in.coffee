EMAIL_INPUT = $('input[name="email"]')
NICKNAME_INPUT = $('input[name="nickname"]')

showSuccess = (nickname) ->
  $('.signup').addClass('hidden')
  $('.email-output').text(nickname)
  $('.signup-success').removeClass('hidden')

submitSignUpForm = (email, nickname) ->
  $.ajax
    url: '/new-sign-up'
    type: 'POST'
    data: {
      'email': email
      'nickname': nickname
      }
    success: (response) ->
      showSuccess(nickname)

$('form.sign-up').submit (event) ->
  event.preventDefault()
  email = EMAIL_INPUT.val().trim()
  nickname = NICKNAME_INPUT.val().trim()
  if email and nickname
    $.ajax
      url: '/is-valid-email'
      type: 'POST'
      data: {'email': email}
      success: (isValidEmail) ->
        console.log isValidEmail
        if isValidEmail is true
          clearFieldErrors()
          submitSignUpForm(email, nickname)
        else
          EMAIL_INPUT.addClass 'error'
          false
  else
    clearFieldErrors()
    addErrorsToEmptyFields(email, nickname)

addErrorsToEmptyFields = (email, nickname) ->
  unless email
    EMAIL_INPUT.addClass 'error'
  unless name
    NICKNAME_INPUT.addClass 'error'

clearFieldErrors = ->
    EMAIL_INPUT.removeClass 'error'
    NICKNAME_INPUT.removeClass 'error'
