async   = require 'async'
Crawler = require('crawler').Crawler

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

crawl = (url, done) ->
  crawler = new Crawler
    forceUTF8: true
    callback: (err, result, $) ->
      done err, $
  crawler.queue url

fetch = (res) ->
  matches = res.message.match(urlRegex)
  return unless matches?

  async.map matches, crawl, (err, jQueries) =>
    return @error err if err?

    titles = jQueries.map ($) ->
      $('title').text().trim()
    .join ', '

    @say res.channel, titles if not not titles

routes = {}
routes['*'] = fetch

module.exports =
  routes: routes
