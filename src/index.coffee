_       = require 'underscore'
title   = require 'url-to-title'

urlRegex = /(\b(?:https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

match = (message) ->
  return [] unless message? and typeof message is 'string'
  message.match(urlRegex) or []

fetch = (res, callback) ->
  matches = match res.message
  return unless matches?

  title matches
  .then (results) =>
    titles = _.compact results
      .map (title) ->
        title.trim()

    return if titles.length is 0

    @say res.channel, titles.join ', '

  .catch @error

module.exports =
  routes: [
    path: urlRegex
    handler: fetch
  ]

if process.env.NODE_ENV is 'test'
  module.exports.fetch = fetch
  module.exports.match = match
