# The Cinister framework.
# Copyright (c) Sourav Datta, soura.jagat@gmail.com (2013)

http = require 'connect'
url = require 'url'
utils = require './ciniutils'
qs = require 'querystring'

cin = exports

cin.process_url = (url) ->
  # If the URL doesn't begin with '/', then add
  if url[0] != '/'
    url = '/' + url
  # If url ends with '/', remove it
  if url.lastIndexOf('/') == (url.length - 1)
    url = url.substring 0, (url.length - 1)
  url

cin.pageError = (res) ->
  res.writeHead 404, 'Content-Type': 'text/html'
  res.end '<b>404 - page not found</b>'
  
class ReqHandler
  url_map: {
    'GET': [],
    'POST': [],
    'PUT': [],
    'DELETE': []
  }
  
  add: (url, method, fn) ->
    @url_map[method].push({url_pat: url, url_fn: fn})
    
  get: (url, method, query, session) ->
    for u in @url_map[method]
      ret = utils.match_url utils.slice_string(u.url_pat), utils.slice_string(url)
      if ret[0] == true
        params = ret[1]
        params['session'] = session
        params['query'] = query
        return u.url_fn(params)
    return false
    
cin.ReqHandler = ReqHandler
  
class HttpServer
  @instance: null
  
  @getOne: (port_num) ->
    if HttpServer.instance == null
      HttpServer.instance = new HttpServer port_num
    return HttpServer.instance
  
  req_hnd: new ReqHandler
  
  constructor: (@port) ->
    @port = 8080 if not @port
    
  route: (url, method, fn) ->
    @req_hnd.add(url, method, fn)
    
  session_enabled: false
    
  enable: (what) ->
    if what.toUpperCase() == 'SESSION'
      @session_enabled = true
  
  respond: (path, method, query, res, session) ->
    response = @req_hnd.get(path, method, query, session) 
    if response != false
      res.writeHead 200, 'Content-Type': 'text/html'
      res.end response
    else
      cin.pageError res
    
  run: ->
    @server = http().use(http.favicon()).use(http.logger('dev'))
    if @session_enabled
      @server.use http.cookieParser()
      @server.use http.session(secret: 'appleAMIGOarmageddon', cookie: {maxAge: 10000000})
    @server.use (req, res) =>
      url_parts = url.parse(req.url, true)
      query = {}
      body = ''
      if req.method != 'GET'
        # parse body
        req.on 'data', (data) =>
          body += data.toString()
        req.on 'end', =>
          query = qs.parse(body)
          @respond url_parts.pathname, req.method, query, res, req.session
      else
        query = url_parts.query
        @respond url_parts.pathname, req.method, query, res, req.session
    @server.listen @port
    console.log 'Running on ', @port
    
cin.CinServer = HttpServer

cin.port = (port_num) ->
  HttpServer.getOne(port_num)
  
cin.get = (url, fn) ->
  HttpServer.getOne().route(url, 'GET', fn)
  
cin.post = (url, fn) ->
  HttpServer.getOne().route(url, 'POST', fn)
  
cin.put = (url, fn) ->
  HttpServer.getOne().route(url, 'PUT', fn)
  
cin.delete = (url, fn) ->
  HttpServer.getOne().route(url, 'DELETE', fn)
  
cin.enable_session = ->
  HttpServer.getOne().enable 'session'
  
cin.start = -> HttpServer.getOne().run()
