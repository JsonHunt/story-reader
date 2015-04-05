@RootController = ($scope, $location) ->
	empty = []
	storiesString = window.localStorage.getItem("stories")
	if storiesString is null
		storiesString = JSON.stringify([])

	$scope.stories = JSON.parse(storiesString)
	wordsString = window.localStorage.getItem("words")
	if wordsString is null
		wordsString = JSON.stringify([])

	$scope.allWords = JSON.parse(wordsString)

@RootController.$inject = [ '$scope', '$location']
