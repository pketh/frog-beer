EMAIL_INPUT = $('input[name="email"]')
NAME_INPUT = $('input[name="name"]')

submitSignUpForm = (email, name) ->
  $.ajax
    url: '/sign-up'
    type: 'POST'
    data: {
      'email': email
      'name': name
      }
    success: (response) ->
      console.log response

$('form.sign-up').submit (event) ->
  event.preventDefault()
  email = EMAIL_INPUT.val().trim()
  name = NAME_INPUT.val().trim()
  if email and name
    $.ajax
      url: '/is-valid-email'
      type: 'POST'
      data: {'email': email}
      success: (isValidEmail) ->
        console.log isValidEmail
        if isValidEmail is true
          clearFieldErrors()
          submitSignUpForm(email, name)
        else
          EMAIL_INPUT.addClass('error')
          false
  else
    clearFieldErrors()
    addErrorsToEmptyFields(email, name)

addErrorsToEmptyFields = (email, name) ->
  unless email
    EMAIL_INPUT.addClass('error')
  unless name
    NAME_INPUT.addClass('error')

clearFieldErrors = ->
    EMAIL_INPUT.removeClass('error')
    NAME_INPUT.removeClass('error')
