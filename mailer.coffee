database = require './database'
config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
# http://stackoverflow.com/questions/7625410/render-template-to-variable-in-expressjs
# http://stackoverflow.com/questions/21765107/new-way-to-inline-css

mailer =

  sendSignUp: (email, nickname, signUpToken) ->
    console.log "sending mail to #{nickname}"
    # confirm your acct

module.exports = mailer
