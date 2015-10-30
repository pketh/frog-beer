if process.env.NODE_ENV is 'development'
  GLOBAL.url = "http://localhost:3000"
else
  GLOBAL.url = "http://frog.beer"

# if app.get('env') is 'development'
#   app.use (error, request, response, next) ->
#     response.status error.status or 500
#     response.render 'error',
#       message: error.message
#       error: error
# else
#   app.use (error, request, response, next) ->
#     response.status error.status or 500
#     response.render 'error',
#       message: error.message
#       error: {}
