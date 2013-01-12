moment = require 'moment'

###
  Base Cache Provider

  Provides an in-memory cache object.
###
class BaseCacheProvider
  constructor: () ->
    @cacheObject = {}

  get: (index) ->
    if @cacheObject[index]?

      if moment(@cacheObject[index].cachedUntil) <= moment()
        delete @cacheObject[index]
        return null
      else
        return @cacheObject[index].value

    else
      return null

  set: (key, value, expires) ->

    toCache =
      value: value
      cachedUntil: expires

    @cacheObject[key] = toCache


module.exports = BaseCacheProvider