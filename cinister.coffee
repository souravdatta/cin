# The Cinister framework.
# Copyright (c) Sourav Datta, soura.jagat@gmail.com (2013)

connect = require 'connect'
url = require 'url'
qs = require 'querystring'
ejs = require 'ejs'
fs = require 'fs'
bparser = require 'body-parser'
csession = require 'cookie-session'

cin = exports

class CinUtil
  @slice_string = (str) ->
    if str[0] != '/'
      str = '/' + str
    if str[str.length - 1] != '/'
      str = str + '/'
    str.split('/').slice(1, -1)

  @star_match = (pattern, str) ->
    pattern = pattern.replace(/\./g, '\\.');
    pattern = pattern.replace(/\*/g, '.*');
    pattern = '^' + pattern + '$';
    str.match(new RegExp pattern)

  @match_url = (pattern, url, mapping = {}) ->
    #console.log 'pattern=%s, url=%s, mapping=%s', pattern, url, mapping
    if pattern.length != url.length
      return [false, mapping]

    if pattern.length == 0
      return [true, mapping]

    if pattern[0] == url[0]
      # literal match, do nothing
    else if (pattern[0][0] == ':') and (pattern[0].length > 1)
      # A mand parameter
      mapping[pattern[0].slice(1)] = url[0]
    else if @star_match(pattern[0], url[0])
      # A star match
      if mapping['splat']
        mapping['splat'].push url[0]
      else
        mapping['splat'] = [url[0]]
    else
      return [false, mapping]

    return @match_url pattern.slice(1), url.slice(1), mapping


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
      ret = CinUtil.match_url CinUtil.slice_string(u.url_pat), CinUtil.slice_string(url)
      if ret[0] == true
        params = ret[1]
        params['session'] = session
        params['query'] = query
        return u.url_fn(params)
    return false

cin.ReqHandler = ReqHandler

class ViewTemplate
  @instance: null

  @getOne: ->
    if ViewTemplate.instance == null
      ViewTemplate.instance = new ViewTemplate
    ViewTemplate.instance

  view_root: __dirname + '/views'

  constructor: (root) ->
    if root
      @view_root = root

  root: (new_root) ->
    @view_root = new_root

  ejs: (view_name, data, opt_root) ->
    current_root = @view_root
    if opt_root
      current_root = opt_root
    fileName = "#{current_root}/#{view_name}.ejs"
    try
      file = fs.readFileSync fileName, 'utf8'
      html = ejs.render(file, data)
    catch error
      console.log error
      '<b>404 - page not found</b>'

cin.ViewTemplate = ViewTemplate

class HttpServer
  @instance: null

  @getOne: (port_num) ->
    if HttpServer.instance == null
      HttpServer.instance = new HttpServer port_num
    HttpServer.instance

  req_hnd: new ReqHandler

  constructor: (@port) ->
    @port = 8080 if not @port

  port_number: (port) ->
    @port = port

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
    @server = connect().use bparser.urlencoded(extended: false)
    if @session_enabled
      @server.use csession
        keys: ['Armageddon' + (new Date).getTime(), 'AstlaVista' + (new Date).getTime()]
    @server.use (req, res) =>
      url_parts = url.parse req.url, true
      query = {}
      body = ''
      console.log '%s %s', req.method, decodeURIComponent(url_parts.path)
      if req.method != 'GET'
        # parse body
        req.on 'data', (data) =>
          body += data.toString()
        req.on 'end', =>
          query = qs.parse(body)
          @respond decodeURIComponent(url_parts.path), req.method, query, res, req.session
      else
        query = url_parts.query
        @respond decodeURIComponent(url_parts.path), req.method, query, res, req.session
    @server.listen @port
    console.log 'Running on %s', @port

cin.CinServer = HttpServer

cin.port = (port_num) ->
  HttpServer.getOne().port_number port_num

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

cin.view_root = (vrt) ->
  ViewTemplate.getOne().root(vrt)

cin.ejs = (view_name, data, opt_root) ->
  ViewTemplate.getOne().ejs(view_name, data, opt_root)

cin.start = -> HttpServer.getOne().run()
