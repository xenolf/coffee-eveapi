EveApi = require '../src/eveapi'
BaseCacheProvider = require '../src/baseProvider'
fs = require 'fs'
should = require 'should'

describe 'EveApi', ->

	describe 'constructor', ->

		it 'should default to api.eveonline.com as endpoint address', ->
			eve = new EveApi
			should.exist eve.server
			eve.server.should.eql 'api.eveonline.com'

		it 'should accept a different api endpoint if passed in', ->
			eve = new EveApi 'api.none.it'
			should.exist eve.server
			eve.server.should.eql 'api.none.it'

		it 'should default to api.eveonline.com if an empty api endpoint is passed in', ->
			eve = new EveApi ''
			should.exist eve.server
			eve.server.should.eql 'api.eveonline.com'

		it 'should create a standard BaseCacheProvider if none is passed', ->
			eve = new EveApi
			should.exist eve.cacheProvider
			eve.cacheProvider.should.be.an.instanceof BaseCacheProvider

	describe 'call', ->

		it 'should throw an exception if no callback is passed', ->
			eve = new EveApi
			(->
				eve.call()
			).should.throw 'Must provide a callback!'

		it 'should pass an error object if scope is not defined', (done) ->
			eve = new EveApi
			eve.call {api: 'lol'}, (error, data) ->
				should.not.exist data
				should.exist error
				error.should.eql 'Must provide scope and api in the options object!'
				done()

		it 'should pass an error object if api is not defined', (done) ->
			eve = new EveApi
			eve.call {scope: 'lol'}, (error, data) ->
				should.not.exist data
				should.exist error
				error.should.eql 'Must provide scope and api in the options object!'
				done()

		it 'should pass an error object if no options are provided', (done) ->
			eve = new EveApi
			eve.call {}, (error, data) ->
				should.not.exist data
				should.exist error
				error.should.eql 'Must provide scope and api in the options object!'
				done()

		it 'should pass an error object if options are null', (done) ->
			eve = new EveApi
			eve.call null, (error, data) ->
				should.not.exist data
				should.exist error
				error.should.eql 'Must provide an options object!'
				done()

  describe 'parseXML', ->

    it 'should parse an eve online xml into a js object', (done) ->
      xml = fs.readFileSync __dirname + '/test.xml', 'UTF-8'
      eve = new EveApi
      eve.parseXML xml, (error, obj) ->
        should.not.exist(error)
        obj.should.have.property 'version'
        obj.version.should.eql '2'
        done()

    it 'should return an error message on empty input', (done) ->
    	eve = new EveApi
    	eve.parseXML '', (error, obj) ->
        should.not.exist obj
        should.exist error
        error.should.eql 'XML cannot be empty!'
        done()