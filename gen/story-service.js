// Generated by CoffeeScript 1.9.0
(function() {
  var S, StoryService, storage,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  storage = require('./storage-service');

  S = require('string');

  StoryService = (function() {
    StoryService.prototype.punctuation = ['(', ')', ',', '...', '!', '?', ';', '.', ':', '"'];

    function StoryService() {
      this.savePage = __bind(this.savePage, this);
      this.removePage = __bind(this.removePage, this);
      this.addPage = __bind(this.addPage, this);
      this.getPages = __bind(this.getPages, this);
      this.selectStory = __bind(this.selectStory, this);
      this.removeStory = __bind(this.removeStory, this);
      this.newStory = __bind(this.newStory, this);
      this.resetStories = __bind(this.resetStories, this);
      this.getStories = __bind(this.getStories, this);
      this.stories = storage.loadArray('stories');
    }

    StoryService.prototype.getStories = function() {
      return this.stories;
    };

    StoryService.prototype.resetStories = function() {
      this.stories = [];
      return storage.save(this.stories);
    };

    StoryService.prototype.newStory = function(title, imageURL) {
      var story;
      story = {
        id: storage.getNextID(),
        title: title,
        imageURL: imageURL
      };
      this.stories.push(story);
      storage.save('stories', this.stories);
      this.selectStory(story.id);
      this.addPage(title, imageURL);
      return story;
    };

    StoryService.prototype.removeStory = function(story) {
      _.remove(this.stories, function(s) {
        return s.id === story.id;
      });
      return storage.save('stories', this.stories);
    };

    StoryService.prototype.selectStory = function(storyID) {
      this.pagesKey = "story-pages-" + storyID;
      this.pages = storage.loadArray(this.pagesKey);
      return this.story = _.find(this.stories, function(s) {
        return s.id === storyID;
      });
    };

    StoryService.prototype.getPages = function() {
      return this.pages;
    };

    StoryService.prototype.addPage = function(text, imageURL) {
      var page;
      if (this.story === void 0) {
        console.log("Cannot add page. Story not selected");
        return;
      }
      page = {
        id: storage.getNextID(),
        text: text,
        imageURL: imageURL
      };
      this.pages.push(page);
      return this.savePage(page);
    };

    StoryService.prototype.removePage = function(pageID) {
      if (pageID === this.pages[0].id) {
        return;
      }
      _.remove(this.pages, function(p) {
        return p.id === pageID;
      });
      return storage.save(this.pagesKey, this.pages);
    };

    StoryService.prototype.savePage = function(page) {
      var p, text, _i, _len, _ref;
      _ref = this.punctuation;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        text = S(page.text).replaceAll(p, " " + p + " ").s;
      }
      page.text = S(text).collapseWhitespace().s;
      page.words = text.split(" ");
      storage.save(this.pagesKey, this.pages);
      if (this.pages[0].id === page.id) {
        this.story.title = page.text;
        this.story.imageURL = page.imageURL;
        return storage.save('stories', this.stories);
      }
    };

    return StoryService;

  })();

  module.exports = new StoryService();

}).call(this);
