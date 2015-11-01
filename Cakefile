# export NODE_ENV=development

{spawn, exec} = require 'child_process'

bin = './node_modules/.bin'
js = './public/js'
css = './public/js'

watchedServerFiles = [
  'services/db.coffee'
  'services/helpers.coffee'
  'services/time.coffee'
  'services/s3.coffee'
  'config.json'
  'drawings.coffee'
  'mailer.coffee'
  'palettes.coffee'
  'routes.coffee'
  'scheduled.coffee'
  'server.coffee'
  'topics.coffee'
  'users.coffee'
]

clientCoffeePath = 'public/js/'
clientStylesPath = 'public/css/'

task 'coffee', 'Watch and compile public ☕️  → js', ->
  child = exec "coffee -w -c
    #{clientCoffeePath}draw.coffee
    #{clientCoffeePath}sign-up-in.coffee
    #{clientCoffeePath}sign-out.coffee
    #{clientCoffeePath}unsubscribe.coffee
    #{clientCoffeePath}account.coffee"
  child.stdout.on 'data', (data) -> console.log data

task 'setup', 'Setup environment from packages', ->
  install = exec 'sudo npm install', stdio: 'inherit'
  install.stdout.on 'data', (data) -> console.log data.toString().trim()
  install.on 'exit', ->
    update = exec 'sudo npm update', stdio: 'inherit'
    update.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'start', 'Start 🐸 🍺', (options) ->
  watchList = ''
  AddToWatchList = (file) ->
    watchList += '-w ' + file + ' '
  AddToWatchList file for file in watchedServerFiles
  child = exec 'nodemon --exec DEBUG=frog-beer:* ./bin/www ' + watchList
  child.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'styles', 'Watch and compile styl → css', ->
  child = exec "stylus --watch
    #{clientStylesPath}styles.styl
    #{clientStylesPath}emails.styl
    -u autoprefixer-stylus"
  child.stdout.on 'data', (data) -> console.log data

option '-u', '--upgrade', 'upgrade package.json dependencies to match latest versions'

task 'update', 'Checks for updates to packages', (options) ->
  if options.upgrade is true
    update = exec 'npm-check-updates -u', stdio: 'inherit'
    update.stdout.on 'data', (data) -> console.log data.toString().trim()
  else
    spawn 'npm-check-updates', [], stdio: 'inherit'


# incomplete tasks:

task 'dev', 'Switches environment to development', ->
  console.log "this doesn't work yet"
  exec 'export NODE_ENV=development'

task 'prod', 'Switches environment to production', ->
  console.log "this doesn't work yet"
  exec 'export NODE_ENV=production'
