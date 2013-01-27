PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean-docs clean build test dist publish

init:
	npm install

clean:
	rm -rf lib/ && rm -rf static/evedump.db

build: deps clean
	coffee -j index.js -o lib/ -c src/

test: build
	mocha --compilers coffee:coffee-script --require should

deps:
	@test `which coffee` || echo 'You need to have CoffeeScript in your PATH.\nPlease install it using `brew install coffee-script` or `npm install coffee-script`.'
	@test `which mocha` || echo 'You need to have mocha installed to run tests!'

dist: init test build

publish: dist
	npm publish