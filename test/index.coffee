assert = require 'assert'

class Domo
  constructor: ->
  error: (err) ->
    throw err

describe 'Title parser', ->
  it 'should return parsed title from HTML', () ->
    parser = require('../index').parseTitle
    html = '<html><head><title>domo-url-test</title></head><body></body></html>'
    assert.equal parser(html), 'domo-url-test'


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

  it 'should return titles of multiple urls', (done) ->

    domo = new Domo

    domo.route = (regex, route) ->
      route.call domo,
        message: 'foo https://github.com/rikukissa/domo bar https://github.com/rikukissa/domo-url'
        channel: '#test'

    domo.say = (channel, msg) ->
      assert.equal msg, 'rikukissa/domo · GitHub, rikukissa/domo-url · GitHub'
      done()

    require('../index').init domo

  it 'should know how to handle scandinavian characters', (done) ->
    domo = new Domo

    domo.route = (regex, route) ->
      route.call domo,
        message: 'http://www.iltalehti.fi/uutiset/2013100717573790_uu.shtml'
        channel: '#test'

    domo.say = (channel, msg) ->
      assert.equal msg, 'Jyrkkä lasku tyytyväisyydessä! Suomalaiset nyreissään pankeille | Kotimaan uutiset | Iltalehti.fi'
      done()

    require('../index').init domo

