'use strict';
var messages = require('./controllers/messages');
var route = require('koa-route');
var koa = require('koa');
var path = require('path');
var app = module.exports = koa();

app.use(route.get('/communications', messages.fetch));

if (!module.parent) {
  app.listen(3000);
  console.log('listening on port 3000');
}
