var async, cheerio, init, parseTitle, request, sanitizeTitle, urlRegex, _;

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

init = function(domo) {
  return domo.route(urlRegex, function(res) {
    var urlRequests;
    urlRequests = _.map(res.message.match(urlRegex), function(url) {
      return {
        encoding: 'utf-8',
        uri: url
      };
    });
    return async.map(urlRequests, request, function(err, responses) {
      var titles;
      if (err != null) {
        return domo.error(err);
      }
      titles = responses.filter(function(response) {
        if (response.statusCode !== 200) {
          return false;
        }
        response.title = parseTitle(response.body);
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
