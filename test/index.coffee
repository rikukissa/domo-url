assert = require 'assert'

describe 'URL regex route', ->

  routes = require('../index').routes

  for key, fn of routes
    routeFn = fn
    break

  it 'should return the title of the sent url', (done) ->

    context =
      say: (chan, title) ->
        assert.equal title, 'Mongoose API v3.8.8'
        done()

    routeFn.call context,
      channel: '#foo'
      message: 'http://mongoosejs.com/docs/api.html'

  it 'should return titles of multiple urls', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, '    imgur: the simple image sharer, CodePen - Front End Developer Playground & Code Editor in the Browser'
        done()

    routeFn.call context,
      channel: '#foo'
      message: 'foo http://imgur.com/ bar http://codepen.io/'


  it 'should know how to handle scandinavian characters', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'Jyrkkä lasku tyytyväisyydessä! Suomalaiset nyreissään pankeille | Kotimaan uutiset | Iltalehti.fi'
        done()

    routeFn.call context,
      channel: '#foo'
      message: 'http://www.iltalehti.fi/uutiset/2013100717573790_uu.shtml'

  it 'should know how to handle scandinavian characters when content type charset is UTF-8', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'Huolimattomalle tankkaajalle voi räpsähtää tuhansien eurojen lasku | Yle Uutiset | yle.fi'
        done()

    routeFn.call context,
      channel: '#foo'
      message: 'http://yle.fi/uutiset/huolimattomalle_tankkaajalle_voi_rapsahtaa_tuhansien_eurojen_lasku/6870876'

