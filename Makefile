PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean-docs clean build test dist publish

init:
	npm install

clean:
	rm -rf lib/ && rm static/evedump.db

build: deps
	coffee -o lib/ -c src/

test: deps
	mocha --compilers coffee:coffee-script --require should

deps:
	@test `which coffee` || echo 'You need to have CoffeeScript in your PATH.\nPlease install it using `brew install coffee-script` or `npm install coffee-script`.'
	@test `which mocha` || echo 'You need to have mocha installed to run tests!'

dist: clean init build test

publish: dist
	npm publish