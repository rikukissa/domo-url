assert = require 'assert'

describe 'Title fetcher', ->
  fetch = require('../index').fetch

  it 'should return the title of the sent url', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'Mongoose API v3.8.12'
        done()

    fetch.call context,
      channel: '#foo'
      message: 'http://mongoosejs.com/docs/api.html'

  it 'should return titles of multiple urls', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'imgur: the simple image sharer, CodePen - Front End Developer Playground & Code Editor in the Browser'
        done()

    fetch.call context,
      channel: '#foo'
      message: 'foo http://imgur.com/ bar http://codepen.io/'


  it 'should know how to handle scandinavian characters', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'Jyrkkä lasku tyytyväisyydessä! Suomalaiset nyreissään pankeille | Kotimaan uutiset | Iltalehti.fi'
        done()

    fetch.call context,
      channel: '#foo'
      message: 'http://www.iltalehti.fi/uutiset/2013100717573790_uu.shtml'

  it 'should know how to handle scandinavian characters when content type charset is UTF-8', (done) ->
    context =
      say: (chan, title) ->
        assert.equal title, 'Huolimattomalle tankkaajalle voi räpsähtää tuhansien eurojen lasku | Yle Uutiset | yle.fi'
        done()

    fetch.call context,
      channel: '#foo'
      message: 'http://yle.fi/uutiset/huolimattomalle_tankkaajalle_voi_rapsahtaa_tuhansien_eurojen_lasku/6870876'

  it 'should know how to handle plain files', (done) ->
    fetch.call context,
      channel: '#foo'
      message: 'http://i.imgur.com/qXiruBO.png'
    , -> done()

describe 'URL matcher', ->
  match = require('../index').match

  it 'should match urls', ->
    assert.deepEqual match('http://imgur.com/'), ['http://imgur.com/']

  it 'should match multiple urls', ->
    assert.deepEqual match('http://imgur.com/ http://codepen.io/'), ['http://imgur.com/', 'http://codepen.io/']

  it 'should ignore not-url text in the middle of 2 urls, in front of them and after them', ->
    assert.deepEqual match('ldsldsllsd http://imgur.com/ adfa http://codepen.io/ sdfslkhf'), ['http://imgur.com/', 'http://codepen.io/']

  it 'should return an empty array if no url is found', ->
    assert.deepEqual match('foo'), []

  it 'should return an empty array if message is empty', ->
    assert.deepEqual match(''), []

  it 'should return an empty array if message is null', ->
    assert.deepEqual match(null), []

  it 'should return an empty array if message is undefined', ->
    assert.deepEqual match(), []

  it 'should return an empty array if message is something weird', ->
    assert.deepEqual match('joku oli vääntäny jonku valmiin libin millä pysty sylkee vaa {% thumbnail %} template tageihin että minkäkokosta tilataan'), []
