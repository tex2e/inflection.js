
js: js/inflection.js
min.js: js/inflection.min.js

js/inflection.js: coffee/inflection.coffee
	coffee --bare --compile --output js/ coffee/

js/inflection.min.js: js/inflection.js
	uglifyjs --compress --mangle -- $? > $@
