ent       = require 'ent'
iconv     = require 'iconv-lite'
jschardet = require 'jschardet'

module.exports = (text, charset) ->

  unless charset?
    { encoding } = jschardet.detect(text)
    charset = encoding if encoding?

  if not iconv.encodingExists(charset) or charset is 'utf-8'
    return ent.decode text.toString('utf-8')

  ent.decode iconv.decode text, charset
