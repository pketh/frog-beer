moment = require 'moment'

year = moment().year()
week = moment().week()

time =

  week: week
  currentWeek: "#{year}-#{week}"
  lastWeek: "#{year}-#{week - 1}"

module.exports = time
