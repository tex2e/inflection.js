
js: js/lib/inflector.js

js/lib/inflector.js: coffee/inflector.coffee
	coffee --bare --compile --output js/lib/ coffee/
