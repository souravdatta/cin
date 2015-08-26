cin = require 'cinister'

cin.port 8084
cin.enable_session()

cin.get '/', -> cin.ejs 'index'

cin.post '/login', (c) ->
  uname = c.query.username
  passwd = c.query.password
  if uname == 'user' && passwd == 'password'
    c.session.name = uname
    c.redirect '/home'
  else
    c.redirect '/'

cin.get '/home', (c) ->
  sess = c.session
  if (not sess) or (not sess.name)
    c.redirect '/'
  else
    cin.ejs 'home', name: c.session.name

cin.start()
