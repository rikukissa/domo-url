async   = require 'async'
cheerio = require 'cheerio'
request = require 'request'
_       = require 'underscore'
_.str   = require 'underscore.string'


urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

parseTitle = (html) ->
  $ = cheerio.load html
  $('title').text()

sanitizeTitle = (title) ->
  _.str.clean title

decode = (body, headers) ->
  if headers['content-type'].indexOf('utf-8') > -1
    body = new Buffer(body, 'binary').toString 'utf-8'
  body

init = (domo) ->
  domo.route urlRegex, (res) ->
    req = request.defaults
      encoding: 'binary'

    async.map res.message.match(urlRegex), req, (err, responses) ->
      return domo.error err if err?

      titles = responses
      .filter (response) ->
        return false unless response.statusCode is 200
        body = decode response.body, response.headers
        response.title = parseTitle body

        not not response.title

      .map (response) ->
        sanitizeTitle response.title

      .join(', ')

      domo.say res.channel, titles if not not titles

module.exports =
  init: init
  parseTitle: parseTitle
  sanitizeTitle: sanitizeTitle
