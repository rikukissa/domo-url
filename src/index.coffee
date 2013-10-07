async   = require 'async'
cheerio = require 'cheerio'
request = require 'request'
_   = require 'underscore.string'

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

module.exports.init = (domo) ->

  domo.route urlRegex, (res) ->

    async.map res.message.match(urlRegex), request, (err, responses) ->
      return domo.error err if err?

      titles = responses
      .filter (response) ->
        return false unless response.statusCode is 200

        $ = cheerio.load(response.body)

        response.title = $('title').text()

        not not response.title

      .map (response) ->
        _.clean response.title

      .join(', ')

      domo.say res.channel, titles if not not titles

