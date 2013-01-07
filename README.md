coffee-eveapi
=============

CoffeScript class for Eve Online API requests

# Compiling
To compile the coffee-script into JS just run
```bash
make generate-js
```

# Usage
Usage is pretty straightforward.
```coffe-script
# require the module
eveapi = require 'coffee-eveapi'

# create a api instance
api = new eveapi

# make an api call
# options is a object which consists at least of 
# 'scope': the scope of the api call (eg. 'account' or 'character')
# 'api': the api to call. Its the url without xml.aspx
api.call options, (error, result) ->
```
