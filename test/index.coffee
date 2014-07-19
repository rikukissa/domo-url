assert = require 'assert'

describe 'Title fetcher', ->
  fetch = require('../index').fetch

  it 'should return the title of the sent url', (done) ->
    context =
      say: (chan, title) ->
        assert.ok title.indexOf('GitHub') > -1
        done()
      error: done

    fetch.call context,
      channel: '#foo'
      message: 'http://github.com'

  it 'should return titles of multiple urls', (done) ->
    context =
      say: (chan, title) ->
        assert.ok title.indexOf('GitHub') > -1 and title.indexOf('imgur') > -1
        done()
      error: done

    fetch.call context,
      channel: '#foo'
      message: 'foo http://imgur.com/ bar http://github.com'

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
