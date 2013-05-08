Cinister is a tiny evolving web framework  (under MIT license) in CoffeeScript and Node.js. I'm mainly writing this to learn both CoffeeScript, JavaScript and Node.js at the same time. 

Huh? 
======================
***


The main goal is to keep things simple, in fact, currently it is so simple that only crucial apps can be made with it. But overtime it will provide more Jelly and Tomatoes! So how does it work? 

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

View the associated cintest.coffee file for usage examples in CoffeeScript.

Fun!

