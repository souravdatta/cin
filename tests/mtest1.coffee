c = require '../cinister'

c.port 8083
c.get '/', -> 'hello world'
c.get '/name/:name', (cin) -> "hello, #{cin.params.name}"
c.start()
