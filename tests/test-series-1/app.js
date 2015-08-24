'use strict';
var messages = require('./controllers/messages');
var logger = require('koa-logger');
var route = require('koa-route');
var koa = require('koa');
var path = require('path');
var app = module.exports = koa();

// Logger
app.use(logger());

app.use(route.get('/:id', messages.fetch));
app.use(route.put('/:id', messages.create));

if (!module.parent) {
  app.listen(3000);
  console.log('listening on port 3000');
}
