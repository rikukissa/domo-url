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

init = (domo) ->

  domo.route urlRegex, (res) ->
    urlRequests = _.map res.message.match(urlRegex), (url) ->
      encoding: 'utf-8'
      uri: url

    async.map urlRequests, request, (err, responses) ->
      return domo.error err if err?

      titles = responses
      .filter (response) ->
        return false unless response.statusCode is 200

        response.title = parseTitle response.body

        not not response.title

      .map (response) ->
        sanitizeTitle response.title

      .join(', ')

      domo.say res.channel, titles if not not titles

module.exports =
  init: init
  parseTitle: parseTitle
  sanitizeTitle: sanitizeTitle
