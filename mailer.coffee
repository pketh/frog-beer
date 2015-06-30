database = require './database'
config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
# http://stackoverflow.com/questions/7625410/render-template-to-variable-in-expressjs
# http://stackoverflow.com/questions/21765107/new-way-to-inline-css

mailer = {}

hello = '🐸 Our pact' # union of blood .. # thou shalt.. confirm your acct .. time for art

module.exports = mailer
