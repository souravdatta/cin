Cinister is a tiny evolving web framework  (under MIT license) in CoffeeScript and Node.js heavily inspired
by Ruby's excellent Sinatra and Python's Flask frameworks. I'm mainly writing this to learn both CoffeeScript, JavaScript and Node.js at the same time.

Huh?
======================
***


The main goal is to keep things simple, currently it supports RESTful URL patterns for tiny apps and GET, POST, PUT and DELETE http methods.
But overtime it will provide more Jelly and Tomatoes for the stars! So how does it work?

* You gonna need [Node.js](http://nodejs.org/) installed for this.
* Also, since its a [CoffeeScript](http://coffeescript.org/) (sip) project you need to install that as well.

**Getting Cinister**

You can download the source code from the above links or more simply can run this from npm

`npm install cinister`

Cinister has dependency on [`ejs`, `connect`, `querystring`]

**Creating an app**

We are going to make a simple app that says 'Hi' on launch and runs on localhost at port 9000.

`cin = require 'cinister'`

This gets Cin classes and functions ready for your app.

`cin.port 9000`

This sets the port of our app server to 9000.

`cin.get '/', -> '<h1>Hi</h1>'`

This creates a route for our app. The route is root or '/' and on hitting it the page will greet you with Hi.

`cin.start()`

And finally this starts the app.

Put the above lines in a file, say app1.coffee, and run

`coffee app1.coffee`

Now navigate to http://localhost:9000/ to see your message.

Cinister is written in CoffeeScript but that doesn't mean it can't run with plain vanilla JavaScript. Cinister can be used along with just Node.js in the same way as above. Here's a much contrived example in JavaScript -

[Cinister in JavaScript](https://gist.github.com/souravdatta/5538500)

**RESTful URLS**

The way you add REST apis to your app is as follows:

1. Call builtin functions `get`, `put`, `delete` and `post` to create new routes.
2. These functions take two parameters - a. an URL pattern and b. a function as action.
3. The action function optionally takes a single argument which exposes the internals to the function.
4. Currently the following are available through the argument passed to action function:
      a. `param` - this exposes all the matched url parts. Example below.
      b. `query` - this exposes the query string parameters.
      c. `session` - exposes a session object where objects can be stored.
      d. `redirect` - exposes a function to redirect to another URL.

Cinister supports various patterns of URLs and methods. Here are some examples:

    cin.get 'users/:name', (c) -> console.log c.params.name, c.query  
    cin.get

The `c.params` parameter will contain all the `:argument`s as key/value pairs. The key will be `argument` and value will the be the corresponding part in the URL. The `c.redirect` object will always return a function which can be used to redirect to another url. So if the a GET request has URL `users/John`, `c.params.name` will be `'John'`.

    cin.get 'users/:name/len*', (c) -> "#{c.params['name']} and #{c.params.splat[0]}"
    cin.get 'users/:name/*/*', (c) -> console.log c.params
    cin.get 'users/:name/*/and/*', (c) -> console.log c.params

And, to redirect to a new url

    cin.get '/users/name/:name', (c) ->
      if c.params.name == 'John Snow'
        c.redirect '/wall'
      else
        "Hello there <b><i>#{c.params.name}</i></b>"

A star indicates one or more characters and the matched URL parts are kept as an array in `c.params['splat']`. A `*.*` matches all file names with any extensions.

    cin.put 'users', (c) -> console.log 'PUT ', c.params
    cin.delete 'foods', (c) -> console.log 'DEL ', c.params
    cin.post 'apaches', (c) -> console.log 'POST', c.params

The nested Object called `c.query` stores the parsed body part of the HTTP request. For GET requests it is taken from the URL itself and for other requests the body of the request is parsed using Node.js querystring module.

View the associated `test/*.coffee` files for usage examples in CoffeeScript.

**Sessions**

Cinister uses Connect as the middleware. For now Cinister has minimal support for session management. Sessions are not enabled by default, but can be enabled by
`cinister.enable_session` function. The argument of the callback handlers always receives an object under `session` key. When the sessions are enabled, this contains the current session object. Here's one small example of how to use it

    cin.enable_session()

    cin.get 'message', (c) ->
      sess = c.session
      if sess && sess.name
        "hello, #{sess.name}\n"
      else
        'hi, one who must not be named\n'

    cin.get 'message/:name', (c) ->
      sess = c.session
      if sess
        sess['name'] = c.params['name']
      'Done\n'

**View templates**

Cinister supports a basic template system which uses the wonderful EJS module. The templates are written in EJS format. Refer to EJS for a detailed description of how to write templates.
The default location for the view templates are ./views directory. However, a separate location can be specified while rendering. Below are two simple examples from cintest2.coffee:

    cin.get 'view1', ->
      cin.ejs 'view1', name: 'Sourav', job: 'Programmer'

    cin.get 'view2', ->
      cin.ejs 'view1', name: 'View2', job: 'Not sure', 'view2'

In the first case, cinister looks for `view1.ejs` under `./views` directory. In the second case it looks for `view1.ejs` under `./view2` directory instead.

**What Cinister is for**

Cinister is mainly for writing quick web apps with small number of interfaces. It is also great for testing and exposing small sets of REST APIs which not only browsers but applications like `curl` can be used to access.

**What Cinister is not for**

Serious web applications, use Express, Rails or even Sinatra. Currently it has very minimal support for sessions, but authentication/cookies will probably be added later.



***License***
***
Copyright (c) 2013 Sourav Datta (soura.jagat@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
