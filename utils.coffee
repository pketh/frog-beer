validator = require 'validator'

utils =

  validateEmail: (request) ->
    email = validator.toString request.body.email
    unless validator.isLength(email, 1, 200)
      throw new Error('email too long')
    console.log 'email'
    return email

  validateName: (request) ->
    name = validator.toString request.body.name
    unless validator.isLength(name, 1, 200)
      throw new Error('name too long')
    return name

module.exports = utils
