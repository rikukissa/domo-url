require('coffee-script/register');

delete require.cache[require.resolve('./src')];

module.exports = require('./src');
