generate-js: deps
	@find src -name '*.coffee' | xargs coffee -c -o lib

remove-js:
	@rm -fr lib/

test: deps
	mocha --compilers coffee:coffee-script --require should

deps:
	@test `which coffee` || echo 'You need to have CoffeeScript in your PATH.\nPlease install it using `brew install coffee-script` or `npm install coffee-script`.'
	@test `which mocha` || echo 'You need to have mocha installed to run tests!'

dev: generate-js
	@coffee -wc --no-wrap -o lib src/*.coffee