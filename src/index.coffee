{createServer} = require 'http'
net = require 'net'
dnode = require 'dnode'
{Router} = require './router'
{Request, Response} = require './resq'
{encode, decode} = require 'coden'

router = new Router

addHandler = (c) ->
    (id, match, handler) ->
        remove = ->
            router.removeHandler id, handler
        c.on 'end', remove
        c.on 'error', remove
        m = router.getMatcher id
        m = router.addMatcher id, match unless m?
        m.addHandler handler

init = (c) ->
    auth: (k, v, cb) ->
        decode v, (err, result) ->
            cb addHandler(c) if not err? and k is result.toString()

server = net.createServer (c) ->
    d = dnode init c
    c.pipe(d).pipe c

server.listen 8522

httpServer = createServer (req, res) ->
    h = router.getHandler(Request req)
    if h?
        h Response res
    else
        res.writeHead 302, Location: 'http://404.htm.im'
        res.end()
    
httpServer.listen 8080
