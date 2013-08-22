qry = require 'qry'

class Matcher
    constructor: (@id, match) ->
        @hdls = []
        @match = qry match
    isMatch: (req) ->
        @match req
    addHandler: (handler) ->
        @hdls.unshift handler

dataHandler = (req, hdl) ->
    (res) -> hdl req, res

class Router
    constructor: ->
        @queue = []
        @idx = {}
    addMatcher: (id, match) ->
        if match?
            matcher = new Matcher id, match
        else
            matcher = id
        @queue.unshift matcher
        @idx[matcher.id] = matcher
    getHandler: (req) ->
        for m in @queue
            if m.isMatch req
                hdl = m.hdls.shift()
                m.hdls.push hdl
                return dataHandler req, hdl
    getMatcher: (id) ->
        @idx[id]
    removeMatcher: (id) ->
        tmp = []
        for m in @queue
            tmp.push m unless m.id is id
        @queue = tmp
        delete @idx[id]
    removeHandler: (id, handler) ->
        tmp = []
        {hdls} = m = @getMatcher id
        for h in hdls
            tmp.push h unless handler is h
        if tmp.length > 0
            m.hdls = tmp
        else
            @removeMatcher id

module.exports = {Matcher, Router}
