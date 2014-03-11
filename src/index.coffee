async   = require 'async'
Crawler = require('crawler').Crawler
_       = require 'underscore'
_.str   = require 'underscore.string'

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

crawl = (url, done) ->
  crawler = new Crawler
    forceUTF8: true
    callback: (err, result, $) ->
      done err, $
  crawler.queue url

fetch = (res) ->
  async.map res.message.match(urlRegex), crawl, (err, jQueries) =>
    return @error err if err?

    titles = jQueries.map ($) ->
      $('title').text()
    .join ', '

    @say res.channel, titles if not not titles

routes = {}
routes[urlRegex] = fetch

module.exports =
  routes: routes
