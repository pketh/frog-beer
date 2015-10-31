config = require '../config.json'
S3 = require 's3'

s3 = new S3.createClient
  s3Options:
    accessKeyId: config.s3.accessKeyId
    secretAccessKey: config.s3.secretAccessKey

module.exports = s3
