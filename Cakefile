development = true

{spawn, exec} = require 'child_process'

bin = './node_modules/.bin'
js = './public/js'
css = './public/js'

watchedServerFiles = [
  'config.json',
  'routes.coffee',
  'server.coffee',
  'store.coffee'
]

task 'coffee', 'Watch and compile public ☕️  → js', ->
  child = exec 'coffee -w -c public/js/frog-beer.coffee'
  child.stdout.on 'data', (data) -> console.log data

task 'setup', 'Setup environment from packages', ->
  install = exec 'sudo npm install', stdio: 'inherit'
  install.stdout.on 'data', (data) -> console.log data.toString().trim()
  install.on 'exit', ->
    update = exec 'sudo npm update', stdio: 'inherit'
    update.stdout.on 'data', (data) -> console.log data.toString().trim()

option '-p', '--prod', 'use production environment'

task 'start', 'Start 🐸 🍺', (options) ->
  if development
    exec 'export NODE_ENV=development'
  else if options.prod is true || development is not true
    exec 'export NODE_ENV=production'
  watchList = ''
  AddToWatchList = (file) ->
    watchList += '-w ' + file + ' '
  AddToWatchList file for file in watchedServerFiles
  child = exec 'nodemon --exec DEBUG=frog-beer:* ./bin/www ' + watchList
  child.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'styles', 'Watch and compile styl → css', ->
  child = exec 'stylus --watch public/css/styles.styl -u autoprefixer-stylus'
  child.stdout.on 'data', (data) -> console.log data

option '-u', '--upgrade', 'upgrade package.json dependencies to match latest versions'

task 'update', 'Checks for updates to packages', (options) ->
  if options.upgrade is true
    update = exec 'npm-check-updates -u', stdio: 'inherit'
    update.stdout.on 'data', (data) -> console.log data.toString().trim()
  else
    spawn 'npm-check-updates', [], stdio: 'inherit'
