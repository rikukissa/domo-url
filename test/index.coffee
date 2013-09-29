assert = require 'assert'

class Domo
  constructor: ->
  error: (err) ->
    throw err

describe 'URL regex route', ->
  it 'should return the title of the sent url', (done) ->
    domo = new Domo
    domo.route = (regex, route) ->
      route.call domo,
        message: 'https://github.com/rikukissa/domo'
        channel: '#test'

    domo.say = (channel, msg) ->
      assert.equal msg, 'rikukissa/domo · GitHub'
      done()

    require('../index').init domo

