{createServer} = require 'http'
{randomBytes} = require 'crypto'
{encode, decode} = require 'coden'

dnode = require 'dnode'
net = require 'net'

{inspect} = require 'util'

httpServer = createServer()


d = dnode()
d.on 'remote', (remote) ->
    k = randomBytes(256).toString 'base64'
    encode k, (err, result) ->
        console.log k
        console.log result
        remote.auth k, result.toString(), (addHandler) ->
            addHandler 'test', {method: 'GET'}, (req, res) ->
                    res Date.now().toString(), 200

c = net.connect host: '127.0.0.1', port: 8522
c.pipe(d).pipe c
