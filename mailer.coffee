frogDB = require './frogDB'
config = require './config.json'
sendgrid = require('sendgrid')(config.sendgrid)
# https://www.npmjs.com/package/email-templates

mailer = {}


module.exports = mailer
