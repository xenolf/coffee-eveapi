querystring = require 'querystring'
https = require 'https'
BaseCacheProvider = require './baseProvider'
sax = require 'sax'
_ = require 'underscore'


###
  EvEApi request class
  Always uses SSL to make requests. No support for EvEApi Proxy or other shit.
###
class EveApi
  ###
  Constructor

  parameters:
    server: api endpoint to contact
    cacheProvider: A provider to in memory cache or another provider.
                   Must extend BaseCacheProvider.
  ###
  constructor: (@server = 'api.eveonline.com', @cacheProvider = new BaseCacheProvider) ->
    if @server is ''
      @server = 'api.eveonline.com'

    if @cacheProvider not instanceof BaseCacheProvider
      throw new Error 'Providers must extend BaseCacheProvider!'

  ###
  Make a api request.
  Uses the configured @server and follows the configured ssl setting.

  The callback HAS to be passed, otherwise you will not get any data.

  If the call fails the callback will get called with an error object and null for data.

  parameters:
    options: options needed for the api call. (api key and other parameters)
             Must provide at least 'scope' and 'api'.
    callback: callback to execute after the call completes

  ###
  call: (options, callback) ->
    if not callback?
      throw new Error 'Must provide a callback!'

    if not options
      callback 'Must provide an options object!', null
      return

    if not options.scope? or not options.api?
      callback 'Must provide scope and api in the options object!', null
      return

    # construct url
    url = "/#{options.scope}/#{options.api}.xml.aspx"

    # construct querystring
    postData = querystring.stringify options

    # check the cache
    cachedResult = @cacheProvider.get url + postData

    if cachedResult?
      callback null, cachedResult
      return

    # no cache hit, execute a http/s request
    options =
      hostname: @server
      port: 443
      path: url
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Length': postData.length

    response = ""
    req = https.request options, (res) =>
      console.log res.statusCode

      res.on 'data', (data) ->
        response += data

      res.on 'end', () =>
        @parseXML response, (error, obj) =>
          @cacheProvider.set url + postData, obj, obj.cachedUntil
          callback null, obj
          return

    req.on 'error', (error) ->
      callback error, null

    req.write postData
    req.end()

  ###
  Takes in an XML string and tries to parse it into a JSON object.

  parameters:
    xmlString: the xml
  ###
  parseXML: (xmlString, callback) ->
    if not xmlString or xmlString is ''
      callback 'XML cannot be empty!', null
      return

    parser = sax.parser false,
      trim: true
      normalize: true
      lowercasetags: true

    jsonObj = {}
    currentNode = ""
    nodeRef = jsonObj

    parser.onerror = (err) ->
      console.log err
      callback err, null

    parser.ontext = (text) ->
      nodeRef[currentNode] = text

    parser.onopentag = (node) ->
      name = node.name

      # use the nodes own name if it exists
      if node.attributes and node.attributes.name
          name = node.attributes.name

      # should not advance hierarchy on row nodes.
      if node.name isnt 'row'
        currentNode = name

        nodeRef[name] =
          parent: nodeRef

        nodeRef = nodeRef[name]

        # special case for rowsets, rows go into arrays
        if node.name is 'rowset'
          nodeRef['rows'] = []

      # stupid saxjs, attributes object exists even if there are no attributes
      if node.attributes and _.size(node.attributes) > 0

        # rowobj is needed for row array population
        rowObj = {}

        # loop through all attributes and add them as properties to the current node object
        # if the current object is a row node, just construct a object of all attribs to add to the array.
        for attribName, attribValue of node.attributes
          if node.name isnt 'row'
            nodeRef[attribName] = attribValue
          else
            rowObj[attribName] = attribValue

        if node.name is 'row'
          nodeRef['rows'].push rowObj

    parser.onclosetag = (node) ->
      # should not step back in the hierarchy on a row node. (row nodes are arrays)
      if node is 'row'
        return

      # concenate objects
      if _.size(nodeRef) is 2 and nodeRef[node]
        nodeRef.parent[node] = nodeRef[node]

      # move hierarchy back one up
      nodeRef = nodeRef.parent

    parser.onend = () ->
      callback null, nodeRef.eveapi

    parser.write xmlString
    parser.close()

module.exports = EveApi