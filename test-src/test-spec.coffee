assert = require 'assert'
sinon = require 'sinon'
storyParser = require './../gen/edit/story-parser'

describe 'Text Parser', ()=>
	it 'parses stories', ()=>
		story = """
		Long time ago, in a land far FAR away. There's lived a "dragon"... big one! How big? Enormous
		"""

		result = storyParser.parse(story)
		assert.equal result.sentences.length, 5, "number of sententece"
		# console.log result.sentences[0].words
		assert.equal result.sentences[0].words.length, 11, "first length"
		# console.log result.sentences[1].words
		assert.equal result.sentences[1].words.length, 7, "second length"
		# console.log result.sentences[2].words
		assert.equal result.sentences[2].words.length, 3, "thirds length"
		# console.log result.sentences[3].words
		assert.equal result.sentences[3].words.length, 3, "fourth length"
		# console.log result.sentences[4].words
		assert.equal result.sentences[4].words.length, 2, "fifth length"

		# console.log result.words
		assert.equal result.words.length, 15, "words length"
