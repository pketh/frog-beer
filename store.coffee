mongo = require 'mongoskin'
config = require './config.json'

store = {} # ..

storeHost = {}
if process.env.NODE_ENV is 'development'
  storeHost = config.store
else
  storeHost = config.storeProd



# var db = require('mongoskin').db('localhost:27017/animals');
#
# db.collection('mamals').find().toArray(function(err, result) {
#   if (err) throw err;
#   console.log(result);
# });


# nano = require('nano')("#{storeHost.url}:#{storeHost.port}")
#
# nano.db.create 'store'
# store = nano.db.use 'store'
#
# # insert {full object}, _id name, callback
#
#
# store.insert {type:'person', fun:true}, 'sup', (err, body, header) ->
#   if err
#     console.log err.message


# want to export a store object which contains shorthands for all 3 collections
module.exports = store

#store.people === db.collection('people')
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
