var async, cheerio, request, urlRegex;

async = require('async');

cheerio = require('cheerio');

request = require('request');

urlRegex = /(\b(?:https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;

module.exports.init = function(domo) {
  return domo.route(urlRegex, function(res) {
    return async.map(res.message.match(urlRegex), request, function(err, responses) {
      var titles;
      if (err != null) {
        return domo.error(err);
      }
      titles = responses.filter(function(response) {
        var $;
        if (response.statusCode !== 200) {
          return false;
        }
        $ = cheerio.load(response.body);
        response.title = $('title').text();
        return !!response.title;
      }).map(function(response) {
        return response.title;
      }).join(', ');
      if (!!titles) {
        return domo.say(res.channel, titles);
      }
    });
  });
};
