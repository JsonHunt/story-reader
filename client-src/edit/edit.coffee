@EditController = ($scope, $location, $routeParams) ->
	$scope.story = $scope.stories[$routeParams.id]
	$scope.save = ()->
		text = $scope.story.text
		if S(text).endsWith('.') is false or S(text).endsWith('!') or S(text).endsWith('?') or S(text).endsWith('...')
			text = $scope.story.text = "#{$scope.story.text}."
		$scope.story.sentences = []
		storyReg = ///[\s\S]*?[\.\!\?](\.\.)?///gm
		punctuation = [',','...','!','?',';','.',':']
		while message = storyReg.exec(text)
			sentenceReg = ///\S+///gm
			words = []
			while word = sentenceReg.exec(message[0])
				word = word[0]
				p = undefined
				for punct in punctuation
					if S(word).endsWith(punct)
						p = punct
						continue
				if p isnt undefined
					if p.length is word.length
						continue
					words.push S(word).strip(p).s
					words.push p
				else
					words.push word

			if words.length > 0
				$scope.story.sentences.push({
					words: words
				})
		$scope.allWords = _.union $scope.allWords, words

		window.localStorage.setItem 'stories', JSON.stringify(@stories)
		window.localStorage.setItem 'words', JSON.stringify(@allWords)
		$location.path 'recording'

	$scope.delete = ()->


@EditController.$inject = [ '$scope','$location', '$routeParams']
