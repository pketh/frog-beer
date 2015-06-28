$('form.sign-up').submit (event) ->
  emailInput = $('input[name="email"]')
  email = emailInput.val()
  nameInput = $('input[name="name"]')
  name = nameInput.val()
  if email and name
    # add procesing ui
    $.ajax
      url: '/is-valid-email'
      type: 'POST'
      data: {'email': email}
      async: false
      success: (isValidEmail) ->
        if isValidEmail
          emailInput.removeClass('error')
          console.log 'is an email'
          # post the form
        else
          # remove processing ui
          emailInput.addClass('error')
    return false
  else
    alert 'not filled'
    false

# $.post( "ajax/test.html", function( data ) {
#   $( ".result" ).html( data );
# });
