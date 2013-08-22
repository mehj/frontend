{parse} = require 'url'

exports.Request = (req) ->
    proto = 'http'
    proto = req.headers['x-forwarded-proto'] if req.headers['x-forwarded-proto']?
    proto = proto.toLowerCase()
    uri = parse (proto + '://' + req.headers.host + req.url), true
    uri.protocol = proto
    {method, headers, url, httpVersion} = req
    {method, headers, url, uri, httpVersion}


exports.Response = (res) ->
    (content, statusCode, headers) ->
        if headers?
            res.writeHead statusCode, headers
        else
            res.statusCode = statusCode            
        res.write content if content?
        res.end()
