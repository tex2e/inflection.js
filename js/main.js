
new Vue({
  el: '#app',
  data: {
    selectedMode: 'Pluralize',
    word: 'person',
  },
  computed: {
    pluralized: function () {
      return pluralize(this.word);
    },
    singularized: function () {
      return singularize(this.word);
    },
  },
});
