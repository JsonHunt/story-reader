S = require "string"
_ = require "underscore"

class StoryParser

	parse: (text)->
		result =
			words: []
			sentences: []


		if !S(text).endsWith('.') or !S(text).endsWith('!') or !S(text).endsWith('?') or !S(text).endsWith('...')
			text += '.'
		storyReg = ///[\s\S]*?[\.\!\?](\.\.)?///gm
		punctuation = ['(',')',',','...','!','?',';','.',':','"']
		for p in punctuation
			text = S(text).replaceAll(p, " #{p} ")

		while message = storyReg.exec(text)
			sentenceReg = ///\S+///gm
			words = []
			while word = sentenceReg.exec(message[0])
				if words.length is 0
					word[0] = S(word[0]).capitalize().s
				words.push word[0]
				if not _.contains(result.words, word[0].toLowerCase()) and not _.contains punctuation, word[0]
					result.words.push word[0].toLowerCase()

			continue if words.length is 0
			continue if words.length is 1 and _.contains(punctuation, words[0])

			result.sentences.push
				words: words

		return result

module.exports = new StoryParser()
