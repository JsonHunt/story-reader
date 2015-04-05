// Generated by CoffeeScript 1.9.0
(function() {
  var StoryParser;

  StoryParser = (function() {
    function StoryParser() {}

    StoryParser.prototype.parse = function(story) {
      var message, p, punct, punctuation, result, sentenceReg, storyReg, text, word, words, _i, _len;
      result = {
        words: [],
        sentences: []
      };
      text = story.text;
      if (!S(text).endsWith('.') || !S(text).endsWith('!') || !S(text).endsWith('?') || !S(text).endsWith('...')) {
        text += '.';
      }
      storyReg = /[\s\S]*?[\.\!\?](\.\.)?/gm;
      punctuation = [',', '...', '!', '?', ';', '.', ':'];
      while (message = storyReg.exec(text)) {
        sentenceReg = /\S+/gm;
        words = [];
        while (word = sentenceReg.exec(message[0])) {
          word = word[0];
          p = void 0;
          for (_i = 0, _len = punctuation.length; _i < _len; _i++) {
            punct = punctuation[_i];
            if (S(word).endsWith(punct)) {
              p = punct;
              continue;
            }
          }
          if (p !== void 0) {
            if (p.length === word.length) {
              continue;
            }
            words.push(S(word).strip(p).s);
            words.push(p);
          } else {
            words.push(word);
          }
        }
        if (words.length > 0) {
          story.sentences.push({
            words: words
          });
          story.words = _.union(story.words, words);
        }
      }
      return result;
    };

    return StoryParser;

  })();

  module.exports = new StoryParser();

}).call(this);
