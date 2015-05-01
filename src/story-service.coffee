storage = require './storage-service'
fileService = require './file-service'
S = require 'string'

class StoryService

	punctuation: ['(',')',',','...','!','?',';','.',':','"']

	constructor: ()->
		@stories = storage.loadArray 'stories'
		@words = storage.load 'words'
		console.log JSON.stringify(@words, null,2)

	initialize: (http)-> @http = htt

	getWords: ()=> @words
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
			@story.imageURL = page.localImageURL
			storage.save 'stories', @stories

		console.log JSON.stringify(@words, null,2)
		async.eachSeries page.words, (word,next)=>
			# if _.isString @words[word]
			# 	delete @words[word]
			w = storage.load "word-#{word}"
			if w.text is undefined
				w.text = word
				storage.save "word-#{word}", w
			if !_.contains(@punctuation, word) and w.audioURL is undefined
				url = "http://translate.google.com/translate_tts?tl=en&q=#{word}"
				filename = "words/#{word}.mp3"
				fileService.downloadFile url,filename, (path)=>
					w.audioURL = path
					storage.save "word-#{word}", w
					next()
			else next()
		, (err)=>
			console.log 'All words saved'




module.exports = new StoryService()
