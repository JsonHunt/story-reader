@StoryController = ($scope, $location, $routeParams, $timeout) ->

	$scope.story = $scope.stories[$routeParams.id]
	$scope.story.sentences = [] if $scope.story.sentences is undefined


	$scope.player =
		play: (word, callback) ->
			$scope.timer = $timeout ()->
				callback()
			,1000
	# _.each($scope.story.text.split('.'), function(s){
	# 	$scope.sentences.push({
	# 		words: s.split(/[\s,]+/)
	# 	});
	# });
	$scope.selected = {}

	$scope.isEnd = $scope.sentenceIndex == $scope.story.sentences.length - 1

	if $scope.story.sentences.length > 0
		$scope.sentenceIndex = 0
		$scope.sentence = $scope.story.sentences[0]

	$scope.read = (word) ->
		$scope.selected.word = word
		$timeout.cancel($scope.timer)
		$scope.player.play word, ()->
			$scope.selected.word = undefined
			return

	$scope.nextSentence = ()->
		@reading = undefined;
		@sentenceIndex++
		if @sentenceIndex < @story.sentences.length
			@sentence = @story.sentences[@sentenceIndex]

		@isEnd = @sentenceIndex == @story.sentences.length - 1

	$scope.end = ()->
		$location.path('/')

	$scope.edit = ()->
		$location.path("edit/#{$scope.story.id}")

@StoryController.$inject = [ '$scope','$location','$routeParams','$timeout']
