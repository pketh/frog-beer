GetQueryStringParams = (param) ->
    pageURL = window.location.search.substring 1
    URLVariables = pageURL.split '&'
    for URLVariable, i in URLVariables
      parameterName = URLVariables[i].split('=')
      if parameterName[0] is param
        return parameterName[1]

signUpToken = GetQueryStringParams('signUpToken')
accountCookie = Cookies.get().accountToken
anonymousDrawing = Cookies.get('drawing')

if accountCookie
  $.ajax
    url: '/get-user-name'
    type: 'POST'
    data: {
      'accountCookie': accountCookie
      }
    success: (response) ->
      userName = response
      $('.user-name').html(userName)
else if signUpToken
  $.ajax
    url: '/add-account-token'
    type: 'POST'
    data: {
      'signUpToken': signUpToken
      }
    success: (response) ->
      accountToken = response
      Cookies.set 'accountToken', accountToken, { expires: 10000 }
      console.log "cookie saved! #{accountToken}"
      location.reload()

if accountCookie and anonymousDrawing
  $.post '/move-drawing-to-week', {'drawing': anonymousDrawing}, (response) ->
    Cookies.remove('drawing')
    console.log 'anon drawing cookie removed'
