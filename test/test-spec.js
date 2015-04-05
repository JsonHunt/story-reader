// Generated by CoffeeScript 1.9.0
(function() {
  var assert, sinon, storyParser;

  assert = require('assert');

  sinon = require('sinon');

  storyParser = require('./../gen/edit/story-parser');

  describe('Text Parser', (function(_this) {
    return function() {
      return it('parses stories', function() {
        var result, story;
        story = "Long time ago, in a land far FAR away. There's lived a \"dragon\"... big one! How big? Enormous";
        result = storyParser.parse(story);
        assert.equal(result.sentences.length, 5, "number of sententece");
        assert.equal(result.sentences[0].words.length, 11, "first length");
        assert.equal(result.sentences[1].words.length, 7, "second length");
        assert.equal(result.sentences[2].words.length, 3, "thirds length");
        assert.equal(result.sentences[3].words.length, 3, "fourth length");
        assert.equal(result.sentences[4].words.length, 2, "fifth length");
        return assert.equal(result.words.length, 15, "words length");
      });
    };
  })(this));

}).call(this);