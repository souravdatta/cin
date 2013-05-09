# A simple test of Cinister (as it is now)
# Copyright (c) Sourav Datta, soura.jagat@gmail.com (2013)

cin = require 'cinister'

cin.port 8080
cin.get '/', -> 
  '<b>Goto <a href="hello">Hello</a>' +
  '   Or, say <a href="bye">Bye</a></b><hr/>' +
  '<form action="hello" method="get">' +
  '    <input type="text" name="username"/>' +
  '    <input type="submit"/>' +
  '</form>'  
cin.get '/hello', (params) ->
  #console.log params
  if params.query.username
    "<h1>Hello, #{params.query.username}</h1>"
  else
    '<h1>Hello, anonymous</h1>'
cin.get '/bye', -> '<b>Bye bye</b>'



cin.start()


