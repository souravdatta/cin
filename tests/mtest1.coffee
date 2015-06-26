c = require '../cinister'

c.port 8083
c.get '/', -> 'hello world'
c.get '/name/:name', (params) -> "hello, #{params.name}"
c.start()
