GetQueryStringParams = (param) ->
    pageURL = window.location.search.substring 1
    URLVariables = pageURL.split '&'
    for URLVariable, i in URLVariables
      parameterName = URLVariables[i].split('=')
      if parameterName[0] is param
        return parameterName[1]

signUpToken = GetQueryStringParams('signUpToken')

if signUpToken
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
