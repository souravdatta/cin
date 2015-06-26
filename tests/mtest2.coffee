c = require '../cinister'

c.port 8083
c.enable_session()

c.get '/', -> 'better use names'

c.get '/name/:name', (params) ->
  if params.name == 'John Snow'
    params.redirect '/wall'
  else
    params.session.name = params.name

c.get '/hello', (params) -> "<h1>Hello #{params.session.name}</h1>"
c.get '/home', (params) ->
  params.redirect '/'
c.get '/wall', -> 'Welcome to the last frontier in the <b><i>North</i></b>'

c.start()
