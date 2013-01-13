coffee-eveapi
=============

CoffeScript class for Eve Online API requests

# Compiling
To compile the coffee-script into JS just run
```bash
make build
```

# Usage
Usage is pretty straightforward.
```coffe-script
# require the module
eveapi = (require 'coffee-eveapi').EvEApi
evestatic = (require 'coffee-eveapi').EvEStatic

# create a api instance
api = new eveapi

# make an api call
# options is a object which consists at least of 
# 'scope': the scope of the api call (eg. 'account' or 'character')
# 'api': the api to call. Its the url without xml.aspx
api.call options, (error, result) ->
  foo()
```

# License

Copyright (c) 2013 Sebastian Erhart

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
