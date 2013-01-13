EvEStatic = (require '../lib/index').EvEStatic
fs = require 'fs'
should = require 'should'

dbPath = "#{__dirname}/../static/evedump.db"

describe 'EvEStatic', ->

  describe 'constructor', ->

    it 'should set the dbPath and initialized vars', ->
      stat = new EvEStatic
      stat.should.have.ownProperty 'dbFile'
      stat.should.have.ownProperty 'initialized'
      stat.initialized.should.eql false

  describe 'init', ->

    it 'should extract the database if not already existent', (done) ->
      if fs.existsSync dbPath
        fs.unlinkSync dbPath

      stat = new EvEStatic
      stat.init (error) ->
        fs.existsSync(dbPath).should.be.true
        should.not.exist error
        done()

  describe 'get', ->

    it 'should return an error callback if called before init', (done) ->
      stat = new EvEStatic
      stat.lookup 'test', (error, data) ->
        should.exist error
        should.not.exist data
        error.message.should.eql 'Must call init() first!'
        done()

    it 'should return an error callback if called with an empty name', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.lookup '', (error, result) ->
          should.exist error
          error.message.should.eql 'Pass a valid item name!'
          should.not.exist result
          done()

    it 'should throw an error if invoked without callback', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        (->
          stat.lookup 'Tyrfing'
        ).should.throw 'Must be called with a callback!'
        done()

    it 'should return the right result', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.lookup 'Tyrfing', (error, result) ->
          should.not.exist error
          should.exist result
          result.typeID.should.eql 32342
          done()

      
