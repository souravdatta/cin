# A simple test of Cinister REST like URL support
# Copyright (c) Sourav Datta, soura.jagat@gmail.com (2013)

cin = require 'cinister'

users = ['ini', 'mini', 'myni', 'mo']

cin.port 9000

cin.get '/', -> 'hello, world'

cin.get 'users', ->
  str = 'users => \n'
  for u in users
    str = str + '---- ' + u + '\n'
  str = str + 'done\n'

cin.get 'users/:name', (params) ->
  str = 'user ('
  for u in users
    if u == params['name']
      str = str + u
      break
  str = str + ')\n'
  
cin.get 'users/:name/len*', (params) ->
  str = "length of user(#{params.name}) = "
  len = 0
  
  for u in users
    if u == params.name
      len = params.name.length
      break
      
  str += len + '\n'
  
cin.get 'users/:name/*/*', (params) ->
  str = "For user #{params.name}, #{params.splat[0]} and #{params.splat[1]}\n"
  if params.query
    for k, v of params.query
      str += "#{k} => #{v}\n"
  str
  
cin.put 'users', (params) ->
  if params.query && params.query.name
    users.push params.query.name
    'Added user ' + params.query.name + '\n'
  
cin.post 'users', (params) ->
  if params.query && params.query.command
    cmd = params.query.command
    if cmd == 'all'
      return 'All users\n'
    else
      return 'None'
  'All or None\n'
  
cin.delete 'users', (params) ->
  if params.query && params.query.name
    nusers = []
    for u in users
      if u != params.query.name
        nusers.push(u)
    users = nusers
    'Removed user ' + params.query.name + '\n'
  
cin.start()
