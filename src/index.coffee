async   = require 'async'
Crawler = require('crawler').Crawler

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

crawl = (url, done) ->
  crawler = new Crawler
    forceUTF8: true
    timeout: 5000
    callback: (err, result, $) ->
      done err, $
  crawler.queue url

match = (message) ->
  return [] unless message? and typeof message is 'string'
  message.match(urlRegex) or []

fetch = (res) ->
  matches = match res.message
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

if process.env.NODE_ENV is 'test'
  module.exports.crawl = crawl
  module.exports.fetch = fetch
  module.exports.match = match
