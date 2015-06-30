mongo = require 'mongoskin'
config = require './config.json'

database = {}

if process.env.NODE_ENV is 'development'
  database.path = "mongodb://#{config.frogDevDB.user}:#{config.frogDevDB.password}@#{config.frogDevDB.path}"
else
  database.path = "mongodb://#{config.frogProdDB.user}:#{config.frogProdDB.password}@#{config.frogProdDB.path}"

module.exports = database




# var db = require('mongoskin').db('localhost:27017/animals');
#
# db.collection('mamals').find().toArray(function(err, result) {
#   if (err) throw err;
#   console.log(result);
# });#f1f2d8


# store.people === db.collection('people')
# can require the above as... people = require 'store.people' , etc.
## this might be require('store')('people')

# store ==> store.collection('people')
#store.art ...

# *********

# store:
# exports.bread = function bread() {
#   return 'bread: 2';
# };
#
# exports.egg = 'egg: 1';
#
# // exports = {
# //              bread: function bread() { ... },
# //              egg: 'egg: 1'
# //           };

#app:
# var fridge = require ('./fridge');
#
# // var fridge = {
# //                bread: function() { ... },
# //                egg: 'egg: 1'
# //              };
