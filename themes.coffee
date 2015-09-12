# uses the trello board to pick a random theme
# sets currentTheme and lastTheme globally accessible vars

# Trello = req trello lib

config = require './config.json'
# trello = the board

# getBoardInfo:
#
# SelectTheme:
#   retrieve cards in list as array
#   shuffle the array
#   pick one
