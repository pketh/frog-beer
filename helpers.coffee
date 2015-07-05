validator = require 'validator'

helpers =

  isEmail: (email) ->
    validator.isEmail email

  validateEmail: (request) ->
    email = validator.toString request.body.email
    unless validator.isLength(email, 1, 200)
      throw new Error('email too long')
    return email

  validateName: (request) ->
    nickname = validator.toString request.body.nickname
    unless validator.isLength(nickname, 1, 200)
      throw new Error('name too long')
    return nickname
  

module.exports = helpers
