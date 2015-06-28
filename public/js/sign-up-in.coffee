EMAIL_INPUT = $('input[name="email"]')
NAME_INPUT = $('input[name="name"]')

$('form.sign-up').submit (event) ->
  email = EMAIL_INPUT.val()
  name = NAME_INPUT.val()
  if email and name
    $.ajax
      url: '/is-valid-email'
      type: 'POST'
      data: {'email': email}
      async: false
      success: (isValidEmail) ->
        if isValidEmail
          clearFieldErrors()
          # post the form
        else
          EMAIL_INPUT.addClass('error')
    return false
  else
    clearFieldErrors()
    addErrorsToEmptyFields(email, name)
    false

addErrorsToEmptyFields = (email, name) ->
  unless email
    EMAIL_INPUT.addClass('error')
  unless name
    NAME_INPUT.addClass('error')

clearFieldErrors = ->
    EMAIL_INPUT.removeClass('error')
    NAME_INPUT.removeClass('error')
