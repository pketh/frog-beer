# Frog Bar 🐸🌱

## Setup

install dependencies:
```shell
npm install
npm install -g stylus
npm install -g autoprefixer-stylus
npm install -g coffee-script
npm install -g npm-check-updates
```

## Party

run these:
```shell
DEBUG=frog-bar:* ./bin/www
stylus --watch public/css/styles.styl -u autoprefixer-stylus
coffee -w -c public/js/frog-bar.coffee
```

periodically run:
```shell
npm-check-updates
```
