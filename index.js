var async, cheerio, decode, init, parseTitle, request, sanitizeTitle, urlRegex, _;

async = require('async');

cheerio = require('cheerio');

request = require('request');

_ = require('underscore');

_.str = require('underscore.string');

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;

parseTitle = function(html) {
  var $;
  $ = cheerio.load(html);
  return $('title').text();
};

sanitizeTitle = function(title) {
  return _.str.clean(title);
};

decode = function(body, headers) {
  if (headers['content-type'].indexOf('utf-8') > -1) {
    body = new Buffer(body, 'binary').toString('utf-8');
  }
  return body;
};

init = function(domo) {
  return domo.route(urlRegex, function(res) {
    var req;
    req = request.defaults({
      encoding: 'binary'
    });
    return async.map(res.message.match(urlRegex), req, function(err, responses) {
      var titles;
      if (err != null) {
        return domo.error(err);
      }
      titles = responses.filter(function(response) {
        var body;
        if (response.statusCode !== 200) {
          return false;
        }
        body = decode(response.body, response.headers);
        response.title = parseTitle(body);
        return !!response.title;
      }).map(function(response) {
        return sanitizeTitle(response.title);
      }).join(', ');
      if (!!titles) {
        return domo.say(res.channel, titles);
      }
    });
  });
};

module.exports = {
  init: init,
  parseTitle: parseTitle,
  sanitizeTitle: sanitizeTitle
};
