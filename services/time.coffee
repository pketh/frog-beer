moment = require 'moment'

year = moment.utc().year()
week = moment.utc().week()

time =

  week: week
  currentWeek: "#{year}-#{week}"
  lastWeek: "#{year}-#{week - 1}"

module.exports = time
