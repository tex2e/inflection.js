
js: js/lib/inflector.js

js/lib/inflector.js: coffee/inflector.coffee
	coffee --compile --output js/lib/ coffee/
