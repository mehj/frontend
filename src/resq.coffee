{parse} = require 'url'

exports.Request = (req) ->
    proto = 'HTTP'
    proto = req.headers['x-forwarded-proto'] if req.headers['x-forwarded-proto']?
    uri = parse (proto + '://' + req.headers.host + req.url), true
    uri.protocol = proto
    {method, headers, url, httpVersion} = req
    request = {method, headers, url, uri, httpVersion}
    request.onData = (handler) ->
        req.on 'data', (data) ->
            handler data
    request.onEnd = (handler) ->
        req.on 'end', ->
            handler()
    request


exports.Response = (res) ->
    (content, statusCode, headers) ->
        if headers?
            res.writeHead statusCode, headers
        else
            res.statusCode = statusCode            
        res.write content if content?
        res.end()
