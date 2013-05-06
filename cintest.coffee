# A simple test of Cin (as it is now)
# Copyright (c) Sourav Datta, soura.jagat@gmail.com

cin = require('./cin').cin

cin.port 8080
cin.get '/', -> '<b>hello</b>'
cin.get '/hello', -> '<h1>Hello, again</h1>'
cin.get '/bye', -> '<b>Bye bye</b>'
cin.start()

