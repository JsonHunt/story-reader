storage = require './storage-service'
S = require 'string'

class StoryService

	punctuation: ['(',')',',','...','!','?',';','.',':','"']

	constructor: ()->
		@stories = storage.loadArray 'stories'

	getStories: ()=> @stories
	resetStories: ()=>
		@stories = []
		storage.save @stories

	newStory: (title, imageURL)=>
		story =
			id: storage.getNextID()
			title: title
			imageURL: imageURL
		@stories.push story
		storage.save 'stories', @stories

		@selectStory story.id
		@addPage title, imageURL
		story

	removeStory: (story)=>
		_.remove @stories, (s)-> s.id is story.id
		storage.save 'stories', @stories

	selectStory: (storyID)=>
		@pagesKey = "story-pages-#{storyID}"
		@pages = storage.loadArray @pagesKey
		@story = _.find @stories, (s)-> s.id is storyID

	getPages: ()=> @pages

	addPage: (text,imageURL)=>
		if @story is undefined
			console.log "Cannot add page. Story not selected"
			return
		page =
			id: storage.getNextID()
			text: text
			imageURL: imageURL
		@pages.push page
		@savePage page

	removePage: (pageID)=>
		return if pageID is @pages[0].id
		_.remove @pages, (p)-> p.id is pageID
		storage.save @pagesKey, @pages

	savePage: (page)=>
		for p in @punctuation
			text = S(page.text).replaceAll(p," #{p} ").s
		page.text = S(text).collapseWhitespace().s
		page.words = text.split(" ")
		storage.save @pagesKey, @pages

		if @pages[0].id is page.id
			@story.title = page.text
			@story.imageURL = page.imageURL
			storage.save 'stories', @stories






module.exports = new StoryService()
