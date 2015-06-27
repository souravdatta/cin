c = require '../cinister'

c.port 8083
c.enable_session()

c.get '/', -> 'better use names'

c.get '/name/:name', (cin) ->
  params = cin.params
  if params.name == 'John Snow'
    cin.redirect "/wall?name=#{params.name}"
  else
    cin.session.name = params.name

c.get '/hello', (cin) -> "<h1>Hello #{cin.session.name}</h1>"
c.get '/home', (cin) ->
  cin.redirect '/'
c.get '/wall', (cin) -> c.ejs 'wallguys', name: cin.query.name, './views'

c.start()
