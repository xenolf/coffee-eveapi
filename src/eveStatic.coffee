fs = require 'fs'
Buffer = require 'buffer'
zlib = require 'zlib'
sqlite3 = require('sqlite3').verbose()

###
Class for looking up static eve data in a sqlite3 db
###
exports.EvEStatic = class EveStatic

  constructor: ->
    @initialized = false
    @dbFile = "#{__dirname}/../static/evedump.db"
    
  init: (callback) ->
    # if the database file does not yet exist.
    # extract it from the distributed .gz file.
    fs.exists @dbFile, (exists) =>
      if not exists
        gunzip = zlib.createGunzip()

        zipData = fs.readFileSync "#{__dirname}/../static/evedump.db.gz"

        zlib.gunzip zipData, (error, result) =>
          if error
            callback error

          fs.writeFileSync @dbFile, result
          @initialized = true
          @db = new sqlite3.Database @dbFile
          callback null
      else
        @initialized = true
        @db = new sqlite3.Database @dbFile
        callback()



  ###
  Looks for the supplied name in the db and returns the typeID
  ###
  lookup: (name, callback) ->
    if not callback?
      throw new Error 'Must be called with a callback!'

    if not name? or name.length is 0
      callback new Error 'Pass a valid item name!', null

    if not @initialized
      callback new Error 'Must call init() first!', null
      return

    @db.get "SELECT typeID FROM invTypes WHERE typeName = '#{name}'", (err, row) ->
      if err
        callback err, null

      callback null, row