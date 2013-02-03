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

  describe 'findItem', ->
    it 'should return an error callback if called before init', (done) ->
      stat = new EvEStatic
      stat.findItem 'test', (error, data) ->
        should.exist error
        should.not.exist data
        error.message.should.eql 'Must call init() first!'
        done()

    it 'should return an error callback if called with an empty name', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItem '', (error, result) ->
          should.exist error
          error.message.should.eql 'Pass a valid item name!'
          should.not.exist result
          done()

    it 'should throw an error if invoked without callback', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error
        (->
          stat.findItem 'Tyrfing'
        ).should.throw 'Must be called with a callback!'
        done()

    it 'should return the right result', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItem 'Tyrfing', (error, result) ->
          should.not.exist error
          should.exist result
          result.typeID.should.eql 32342
          should.not.exist result.effectID
          done()

    it 'should also work with IDs', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItem '32342', (error, result) ->
          should.not.exist error
          should.exist result
          result.typeID.should.eql 32342
          result.typeName.should.eql 'Tyrfing'
          should.not.exist result.effectID
          done()
    
    

  describe 'findItems', ->

    it 'should return an error callback if called before init', (done) ->
      stat = new EvEStatic
      stat.findItems 'test', (error, data) ->
        should.exist error
        should.not.exist data
        error.message.should.eql 'Must call init() first!'
        done()

    it 'should return an error callback if called with an empty name', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItems '', (error, result) ->
          should.exist error
          error.message.should.eql 'Pass a valid item name!'
          should.not.exist result
          done()

    it 'should throw an error if invoked without callback', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error
        (->
          stat.findItems 'Tyrfing'
        ).should.throw 'Must be called with a callback!'
        done()

    it 'should return an array of found items', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItems ['Tyrfing', 'Erebus', 'Quad 3500mm Gallium Cannon'], (error, result) ->
          should.not.exist error
          should.exist result

          result.should.be.instanceOf Array
          result[0].typeName.should.eql 'Erebus'
          result[0].typeID.should.eql 671
          should.not.exist result[0].effectID

          result[1].typeName.should.eql 'Quad 3500mm Gallium Cannon'
          result[1].typeID.should.eql 3571
          result[1].effectID.should.eql 12

          result[2].typeName.should.eql 'Tyrfing'
          result[2].typeID.should.eql 32342
          should.not.exist result[2].effectID

          done()

    it 'should also work with item IDs', (done) ->
      stat = new EvEStatic
      stat.init (error) ->
        should.not.exist error

        stat.findItems ['32342', '671', '3571'], (error, result) ->
          should.not.exist error
          should.exist result

          result.should.be.instanceOf Array
          result[0].typeName.should.eql 'Erebus'
          result[0].typeID.should.eql 671
          should.not.exist result[0].effectID

          result[1].typeName.should.eql 'Quad 3500mm Gallium Cannon'
          result[1].typeID.should.eql 3571
          result[1].effectID.should.eql 12

          result[2].typeName.should.eql 'Tyrfing'
          result[2].typeID.should.eql 32342
          should.not.exist result[2].effectID

          done()
