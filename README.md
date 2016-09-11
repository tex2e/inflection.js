
Inflector
=================

Inflection pluralizes and singularizes English nouns


Usage
-----------------

```js
pluralize('entry');       // => 'entries'
pluralize('man');         // => 'men'
pluralize('FancyPerson'); // => 'FancyPeople'
pluralize('fish');        // => 'fish'

singularize('buses');       // => 'bus'
singularize('women');       // => 'woman'
singularize('FancyPeople'); // => 'FancyPerson'
singularize('fish');        // => 'fish'
```


Additional Rules
-----------------

Standard rules are from Rails's ActiveSupport
(https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflections.rb)

If you want to register more rules, follow:

```js
Inflector.inflections(function (inflect) {
    inflect.irregular('child', 'children');
    inflect.uncountable('air', 'water', 'electricity');
});
```
