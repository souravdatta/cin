Cinister is a tiny evolving web framework  (under MIT license) in CoffeeScript and Node.js heavily inspired 
by Ruby's excellent Sinatra framework. I'm mainly writing this to learn both CoffeeScript, JavaScript and Node.js at the same time. 

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

_**coffee app1.coffee**_

Now navigate to http://localhost:9000/ to see your message. 

Cinister is written in CoffeeScript but that doesn't mean it can't run with plain vanilla JavaScript. Cinister can be used along with just Node.js in the same way as above. Here's a much contrived example in JavaScript -

[Cinister in JavaScript](https://gist.github.com/souravdatta/5538500)

    var cini = require('cinister');
 
    var make_message = function (name, type) {
      type = type.toUpperCase();
      var html = name + ' is ' + type.toUpperCase();
      if (type === 'GOOD') {
        return '<h1>' + html + '</h1>';
      }
      else if (type === 'BAD') {
        return '<h2>' + html + '</h2>';
      }
      else {
        return '<h3>' + html + '</h3>';
      }
    };
  
    var index_html = '<form method="GET" action="message">' +
                     '  <input type="text" name="name" /> ' +
                     '  <input type="hidden" name="type" value="good" /> ' +
                     '  <input type="submit" />' +
                     '</form> ' +
                     '<form method="GET" action="message">' +
                     '  <input type="text" name="name" /> ' +
                     '  <input type="submit" />' +
                     '  <input type="hidden" name="type" value="bad" /> ' +
                     '</form> ' +
                     '<form method="GET" action="message">' +
                     '  <input type="text" name="name" /> ' +
                     '  <input type="submit" />' +
                     '  <input type="hidden" name="type" value="ugly" /> ' +                 
                     '</form> ';
                 
    cini.port(9000);
    cini.get('/', function () { return index_html; });
    cini.get('message', function (params) {
      if (params.name && params.type) {
        return make_message(params.name, params.type);
      }
      else {
        return '<b>None found</b>';
      }
    });
    cini.start();

<script src="https://gist.github.com/souravdatta/5538500.js"></script>

**RESTful URLS**

Cinister supports various patterns of URLs and methods. Here are some examples:

    cin.get 'users/:name', (params) -> console.log params

The params parameter will contain all the `:argument`s as key/value pairs. The key will be `argument` and value will the be the corresponding part in the URL. So if the a GET request has URL `users/John`, `params.name` will be `'John'`.

    cin.get 'users/:name/len*', (params) -> "#{params['name']} and #{params.splat[0]}"
    cin.get 'users/:name/*/*', (params) -> console.log params
    cin.get 'users/:name/*/and/*', (params) -> console.log params

A star indicates one or more characters and the matched URL parts are kept as an array in `params['splat']`.

    cin.put 'users', (params) -> console.log 'PUT ', params
    cin.delete 'foods', (params) -> console.log 'DEL ', params
    cin.post 'apaches', (params) -> console.log 'POST', params

The `params` argument receives a nested Object called `query` which stores the parsed body part of the HTTP request. For GET reuests this is taken from the URL itself and for other requests the body of the request is parsed using Node.js querystring module.

View the associated cintest*.coffee files for usage examples in CoffeeScript.

Fun!

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
