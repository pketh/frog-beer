S3 = require 's3'
config = require '../config.json'

s3 = new S3.createClient
  s3Options:
    accessKeyId: config.accessKeyId
    secretAccessKey: config.secretAccessKey
    defaultContentType: "image/png"

module.exports = s3
