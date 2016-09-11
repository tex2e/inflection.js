
js: js/inflector.js
min.js: js/inflector.min.js

js/inflector.js: coffee/inflector.coffee
	coffee --bare --compile --output js/ coffee/

js/inflector.min.js: js/inflector.js
	uglifyjs --compress --mangle -- $? > $@
