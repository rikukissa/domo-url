_       = require 'underscore'
async   = require 'async'
request = require 'request'
encoder = require './encoder'

urlRegex = /(\b(?:https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
titleRegex = /(<\s*title[^>]*>(.+?)<\s*\/\s*title)>/
charsetRegex = /charset=(.*)($|;)/

crawl = (url, done) ->
  chunks = []
  headers = null
  title = null

  request
    url: url
    encoding: null
    headers:
      'Accept-Language': 'en-US,en;q=0.8,fi;q=0.6'

  .on 'data', (chunk) ->
    chunks.push chunk

    unless headers?
      headers = @response.headers

      unless headers['content-type']?.indexOf('text/html') > -1
        return @abort()

    # Try to convert html to utf8
    charset = null
    if headers['content-type'].indexOf('charset=') > -1
      match = headers['content-type'].match(/charset=(.*)($|;)/)
      charset = match[1] if match?[1]?

    html = _.map chunks, (chunk) ->
      encoder chunk, charset
    .join ''

    match = titleRegex.exec html

    if match?[2]?
      title = match[2]
      return @abort()

  .on 'error', (err) ->
    done err

  .on 'end', ->
    done null, title


match = (message) ->
  return [] unless message? and typeof message is 'string'
  message.match(urlRegex) or []

fetch = (res, callback) ->

  matches = match res.message
  return unless matches?

  async.map matches, crawl, (err, titles) =>

    return @error err.message if err?

    titles = _.filter titles, (title) ->
      title?
    .map (title) ->
      title.trim()

    @say res.channel, titles.join(', ') if titles.length > 0

    callback?()

module.exports =
  routes: [
    path: urlRegex
    handler: fetch
  ]

if process.env.NODE_ENV is 'test'
  module.exports.crawl = crawl
  module.exports.fetch = fetch
  module.exports.match = match
