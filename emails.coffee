passwordless = require 'passwordless'
MongoStore = require 'passwordless-mongostore'
frogDB = require './frogDB'
# https://www.npmjs.com/package/email-templates

emails = {}

emails.from = 'hi@frog.beer'

# stub
emails.welcome = {
  subject: '🐸🍺 Hi!'
  message: (frogBeer, tokenToSend, uidToSend) ->
    "Hi!,\n
    Welcome to Frog Beer:\n
    use the link below to complete your sign on\n
    http://#{frogBeer}?token=#{tokenToSend}&uid=#{encodeURIComponent(uidToSend)}"
}

module.exports = emails
