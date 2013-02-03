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
  Looks up an array of names or ids and returns an object with name : id : slot (if applicable)
  ###
  findItems: (itemArr, callback) ->
    if not callback?
      throw new Error 'Must be called with a callback!'

    if not itemArr? or itemArr.length is 0
      callback new Error 'Pass a valid item name!', null
      return

    if not @initialized
      callback new Error 'Must call init() first!', null
      return

    inStr = ''
    inStr += '?,' for num in [0 ... itemArr.length]
    inStr = inStr.slice 0, -1

    whereSwitch = if _.isNaN(parseInt itemArr[0]) then 'typeName' else 'typeID'

    @db.all "SELECT i.typeName, i.typeID, e.effectID FROM invTypes as i LEFT JOIN dgmTypeEffects e ON i.typeID = e.typeID AND e.effectID IN (11,12,13,2663) WHERE i.#{whereSwitch} IN (#{inStr})", itemArr, (err, rows) ->
      if err
        callback err, null
        return

      callback null, rows  

  ###
  Looks for the supplied name in the db and returns the typeID
  ###
  findItem: (name, callback) ->
    if not callback?
      throw new Error 'Must be called with a callback!'

    if not name? or name.length is 0
      callback new Error 'Pass a valid item name!', null
      return

    if not @initialized
      callback new Error 'Must call init() first!', null
      return

    whereSwitch = if _.isNaN(parseInt name) then 'typeName' else 'typeID'

    @db.get "SELECT i.typeName, i.typeID , e.effectID FROM invTypes as i LEFT JOIN dgmTypeEffects as e ON i.typeID = e.typeID AND e.effectID IN (11,12,13,2663) WHERE i.#{whereSwitch} = '#{name}'", (err, row) ->
      if err
        callback err, null
        return

      callback null, row