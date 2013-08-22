// Generated by CoffeeScript 1.6.3
(function() {
  var Request, Response, Router, addHandler, createServer, decode, dnode, encode, httpHandler, httpServer, https, httpsServer, init, net, router, server, _ref, _ref1;

  createServer = require('http').createServer;

  https = require('https');

  net = require('net');

  dnode = require('dnode');

  Router = require('./router').Router;

  _ref = require('./resq'), Request = _ref.Request, Response = _ref.Response;

  _ref1 = require('coden'), encode = _ref1.encode, decode = _ref1.decode;

  router = new Router;

  addHandler = function(c) {
    return function(id, match, handler) {
      var m, remove;
      remove = function() {
        return router.removeHandler(id, handler);
      };
      c.on('end', remove);
      c.on('error', remove);
      m = router.getMatcher(id);
      if (m == null) {
        m = router.addMatcher(id, match);
      }
      return m.addHandler(handler);
    };
  };

  init = function(c) {
    return {
      auth: function(k, v, cb) {
        return decode(v, function(err, result) {
          if ((err == null) && k === result.toString()) {
            return cb(addHandler(c));
          }
        });
      }
    };
  };

  server = net.createServer(function(c) {
    var d;
    d = dnode(init(c));
    return c.pipe(d).pipe(c);
  });

  server.listen(8522);

  httpHandler = function(req, res) {
    var h;
    h = router.getHandler(Request(req));
    if (h != null) {
      return h(Response(res));
    } else {
      res.writeHead(302, {
        Location: 'http://404.htm.im'
      });
      return res.end();
    }
  };

  httpServer = createServer(httpHandler);

  httpServer.listen(8080);

  httpsServer = https.createServer(function(req, res) {
    req.headers['x-forwarded-proto'] = 'https';
    return httpHandler(req, res);
  });

  httpsServer.listen(8081);

}).call(this);
