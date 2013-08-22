// Generated by CoffeeScript 1.6.3
(function() {
  var parse;

  parse = require('url').parse;

  exports.Request = function(req) {
    var headers, httpVersion, method, proto, request, uri, url;
    proto = 'HTTP';
    if (req.headers['x-forwarded-proto'] != null) {
      proto = req.headers['x-forwarded-proto'];
    }
    uri = parse(proto + '://' + req.headers.host + req.url, true);
    uri.protocol = proto;
    method = req.method, headers = req.headers, url = req.url, httpVersion = req.httpVersion;
    request = {
      method: method,
      headers: headers,
      url: url,
      uri: uri,
      httpVersion: httpVersion
    };
    request.onData = function(handler) {
      return req.on('data', function(data) {
        return handler(data);
      });
    };
    request.onEnd = function(handler) {
      return req.on('end', function() {
        return handler();
      });
    };
    return request;
  };

  exports.Response = function(res) {
    return function(content, statusCode, headers) {
      if (headers != null) {
        res.writeHead(statusCode, headers);
      } else {
        res.statusCode = statusCode;
      }
      if (content != null) {
        res.write(content);
      }
      return res.end();
    };
  };

}).call(this);