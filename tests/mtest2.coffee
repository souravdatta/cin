c = require '../cinister'

c.port 8083
c.enable_session()

c.get '/', 'better use names'
c.get '/name/:name', (params) -> params.session.name = params.name
c.get '/hello', (params) -> "<h1>Hello #{params.session.name}</h1>"
c.start()
