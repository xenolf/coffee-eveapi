moment = require 'moment'

###
  Base Cache Provider

  Provides an in-memory cache object.
###
exports.BaseCacheProvider = class BaseCacheProvider
  constructor: () ->
    @cacheObject = {}

  get: (index, callback) ->
    if @cacheObject[index]?

      if moment(@cacheObject[index].cachedUntil, 'YYYY-MM-DD HH:mm:ss') <= moment()
        delete @cacheObject[index]
        callback 'Not found', null
      else
        callback null, @cacheObject[index].value

    else
      callback 'Not found', null

  set: (key, value, expires) ->

    toCache =
      value: value
      cachedUntil: moment().add('seconds', expires).format('YYYY-MM-DD HH:mm:ss')

    @cacheObject[key] = toCache