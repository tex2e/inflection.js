
# Rails Active Support
# https://github.com/rails/rails/tree/master/activesupport

# Inflector module
# https://github.com/rails/rails/tree/master/activesupport/lib/active_support/inflector


# Delete the given element from given array.
# If the element isn't in the array, return null and doesn't change the array.
#
#   array = ["apple", "banana", "cherry"]
#   delete_element(array, "banana")
#   array
#   # => ["apple", "cherry"]
#
delete_element = (array, entry) ->
  entry_index = array.indexOf(entry)
  return null if entry_index == -1
  array.splice(entry_index, entry_index)


# helper class for Inflector
class Inflections
  constructor: ->
    @plurals = []
    @singulars = []
    @uncountables = []

  plural: (rule, replacement) ->
    delete_element(@uncountables, rule)
    delete_element(@uncountables, replacement)
    @plurals.splice(0, 0, [rule, replacement])

  singular: (rule, replacement) ->
    delete_element(@uncountables, rule)
    delete_element(@uncountables, replacement)
    @singulars.splice(0, 0, [rule, replacement])

  irregular: (singular, plural) ->
    delete_element(@uncountables, singular)
    delete_element(@uncountables, plural)

    s0 = singular[0]
    srest = singular[1..-1]

    p0 = plural[0]
    prest = plural[1..-1]

    if s0.toUpperCase() == p0.toUpperCase()
      this.plural(///(#{s0})#{srest}$///i, '$1' + prest)
      this.plural(///(#{p0})#{prest}$///i, '$1' + prest)

      this.singular(///(#{s0})#{srest}$///i, '$1' + srest)
      this.singular(///(#{p0})#{prest}$///i, '$1' + srest)
    else
      this.plural(///#{s0.toUpperCase()}(?i)#{srest}$///, p0.toUpperCase() + prest)
      this.plural(///#{s0.toLowerCase()}(?i)#{srest}$///, p0.toLowerCase() + prest)
      this.plural(///#{p0.toUpperCase()}(?i)#{prest}$///, p0.toUpperCase() + prest)
      this.plural(///#{p0.toLowerCase()}(?i)#{prest}$///, p0.toLowerCase() + prest)

      this.singular(///#{s0.toUpperCase()}(?i)#{srest}$///, s0.toUpperCase() + srest)
      this.singular(///#{s0.toLowerCase()}(?i)#{srest}$///, s0.toLowerCase() + srest)
      this.singular(///#{p0.toUpperCase()}(?i)#{prest}$///, s0.toUpperCase() + srest)
      this.singular(///#{p0.toLowerCase()}(?i)#{prest}$///, s0.toLowerCase() + srest)

  uncountable: (words) ->
    Array::push.apply(@uncountables, words)


# The Inflector transforms words from singular to plural.
class Inflector
  @__instance__ = new Inflections

  @inflections: (func) ->
    func.call(null, Inflector.__instance__)

  @inflection: () ->
    Inflector.__instance__


# Applies inflection rules for +singularize+ and +pluralize+.
#
#  apply_inflections('post',  Inflector.inflection().plurals)   # => "posts"
#  apply_inflections('posts', Inflector.inflection().singulars) # => "post"
#
apply_inflections = (word, rules) ->
  return word if word in Inflector.inflection().uncountables
  for replacement in rules
    if word.match(replacement[0])
      return word.replace(replacement[0], replacement[1])

# Returns the plural form of the word in the string.
#
# If passed an optional +locale+ parameter, the word will be
# pluralized using rules defined for that language.
#
#   pluralize('post')             # => "posts"
#   pluralize('octopus')          # => "octopi"
#   pluralize('sheep')            # => "sheep"
#   pluralize('words')            # => "words"
#   pluralize('CamelOctopus')     # => "CamelOctopi"
#
pluralize = (word) ->
  apply_inflections(word, Inflector.inflection().plurals)

# The reverse of #pluralize, returns the singular form of a word in a string.
#
# If passed an optional +locale+ parameter, the word will be
# singularized using rules defined for that language.
#
#   singularize('posts')            # => "post"
#   singularize('octopi')           # => "octopus"
#   singularize('sheep')            # => "sheep"
#   singularize('word')             # => "word"
#   singularize('CamelOctopi')      # => "CamelOctopus"
#
singularize = (word) ->
  apply_inflections(word, Inflector.inflection().singulars)


#--
# Defines the standard inflection rules. These are the starting point for
# new projects and are not considered complete. The current set of inflection
# rules is frozen. This means, we do not change them to become more complete.
# This is a safety measure to keep existing applications from breaking.
#++
Inflector.inflections (inflect) ->
  # these settings are based on:
  # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflections.rb
  inflect.plural(/$/, "s")
  inflect.plural(/s$/i, "s")
  inflect.plural(/^(ax|test)is$/i, '$1es')
  inflect.plural(/(octop|vir)us$/i, '$1i')
  inflect.plural(/(octop|vir)i$/i, '$1i')
  inflect.plural(/(alias|status)$/i, '$1es')
  inflect.plural(/(bu)s$/i, '$1ses')
  inflect.plural(/(buffal|tomat)o$/i, '$1oes')
  inflect.plural(/([ti])um$/i, '$1a')
  inflect.plural(/([ti])a$/i, '$1a')
  inflect.plural(/sis$/i, "ses")
  inflect.plural(/(?:([^f])fe|([lr])f)$/i, '$1$2ves')
  inflect.plural(/(hive)$/i, '$1s')
  inflect.plural(/([^aeiouy]|qu)y$/i, '$1ies')
  inflect.plural(/(x|ch|ss|sh)$/i, '$1es')
  inflect.plural(/(matr|vert|ind)(?:ix|ex)$/i, '$1ices')
  inflect.plural(/^(m|l)ouse$/i, '$1ice')
  inflect.plural(/^(m|l)ice$/i, '$1ice')
  inflect.plural(/^(ox)$/i, '$1en')
  inflect.plural(/^(oxen)$/i, '$1')
  inflect.plural(/(quiz)$/i, '$1zes')

  inflect.singular(/$/, "")
  inflect.singular(/s$/i, "")
  inflect.singular(/(ss)$/i, '$1')
  inflect.singular(/(n)ews$/i, '$1ews')
  inflect.singular(/([ti])a$/i, '$1um')
  inflect.singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i, '$1sis')
  inflect.singular(/(^analy)(sis|ses)$/i, '$1sis')
  inflect.singular(/([^f])ves$/i, '$1fe')
  inflect.singular(/(hive)s$/i, '$1')
  inflect.singular(/(tive)s$/i, '$1')
  inflect.singular(/([lr])ves$/i, '$1f')
  inflect.singular(/([^aeiouy]|qu)ies$/i, '$1y')
  inflect.singular(/(s)eries$/i, '$1eries')
  inflect.singular(/(m)ovies$/i, '$1ovie')
  inflect.singular(/(x|ch|ss|sh)es$/i, '$1')
  inflect.singular(/^(m|l)ice$/i, '$1ouse')
  inflect.singular(/(bus)(es)?$/i, '$1')
  inflect.singular(/(o)es$/i, '$1')
  inflect.singular(/(shoe)s$/i, '$1')
  inflect.singular(/(cris|test)(is|es)$/i, '$1is')
  inflect.singular(/^(a)x[ie]s$/i, '$1xis')
  inflect.singular(/(octop|vir)(us|i)$/i, '$1us')
  inflect.singular(/(alias|status)(es)?$/i, '$1')
  inflect.singular(/^(ox)en/i, '$1')
  inflect.singular(/(vert|ind)ices$/i, '$1ex')
  inflect.singular(/(matr)ices$/i, '$1ix')
  inflect.singular(/(quiz)zes$/i, '$1')
  inflect.singular(/(database)s$/i, '$1')

  inflect.irregular("person", "people")
  inflect.irregular("man", "men")
  inflect.irregular("child", "children")
  inflect.irregular("sex", "sexes")
  inflect.irregular("move", "moves")
  inflect.irregular("zombie", "zombies")

  inflect.uncountable([
    "equipment", "information", "rice", "money",
    "species", "series", "fish", "sheep", "jeans", "police"
  ])
