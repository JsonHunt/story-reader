module.exports = StoryController = ($scope, $location, $routeParams, $timeout) ->

	console.log $routeParams.id
	$scope.story = _.find $scope.stories, (s)-> parseInt(s.id) is parseInt($routeParams.id)
	console.log JSON.stringify($scope.story)
	$scope.story.sentences ?= []
	$scope.isEnd = $scope.sentenceIndex == $scope.story.sentences.length - 1
	$scope.isStart = true

	$scope.capOp = window.localStorage.getItem('caps')
	$scope.recOn = $routeParams.rec
	$scope.showOptions = $routeParams.opt

	punctuation = [',','...','!','?',';','.',':','"']

	if $scope.story.sentences.length > 0
		$scope.sentenceIndex = 0
		$scope.sentence = $scope.story.sentences[0]

	$scope.toggleCaps = ()->
		$scope.stop()
		$scope.capOn = !$scope.capOn
		window.localStorage.setItem 'caps', $scope.capOn

	$scope.toggleRecording = ()->
		$scope.stop()
		$scope.recOn = !$scope.recOn

	$scope.select = (word)->
		return if _.contains punctuation, word
		if !$scope.recOn
			$scope.read word
		else
			if $scope.recording is word
				$scope.recordings[word.toLowerCase()] = true
				$scope.stop()
			else
				if $scope.recording
					$scope.recordings[$scope.recording.toLowerCase()] = true
				$scope.record word

	$scope.record = (word)->
		filename = $scope.folderPath + "/#{word}.mp3"
		$scope.stop()
		console.log "Recording: " + filename
		$timeout ()->
			$scope.recording = word.toLowerCase()
			$scope.media = new Media(
				filename
				(success)->
					$scope.$apply ()->
						$scope.recording = undefined
						$scope.recordings[word.toLowerCase()] = filename
						$scope.media.release()
				(error)->
					console.log JSON.stringify(error)
					$scope.$apply ()->
						$scope.recording = undefined
						$scope.media.release()
				(status)-> console.log JSON.stringify(status)
			)
			$scope.media.startRecord()
		,100

	$scope.read = (word) ->
		return if !$scope.folderPath
		$scope.stop()

		filename = $scope.folderPath + "/#{word}.mp3"
		console.log "Playing: " + filename
		$scope.playing = word.toLowerCase()
		$scope.media = new Media(
			filename
			(success)->
				$scope.$apply ()->
					if $scope.playing is word.toLowerCase()
						$scope.playing = undefined
						$scope.media.release()
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.playing = undefined
					$scope.media.release()
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.play()

	$scope.prevSentence = ()->
		return if @sentenceIndex is 0
		$scope.stop()
		@sentenceIndex--
		@sentence = @story.sentences[@sentenceIndex]

		@isStart = @sentenceIndex is 0
		@isEnd = @sentenceIndex == @story.sentences.length - 1

	$scope.nextSentence = ()->
		return if @sentenceIndex is @story.sentences.length-1
		$scope.stop()
		@sentenceIndex++
		@sentence = @story.sentences[@sentenceIndex]

		@isStart = false
		@isEnd = @sentenceIndex == @story.sentences.length - 1

	$scope.stop = ()->
		if $scope.playing
			$scope.playing = undefined
			if $scope.media
				$scope.media.stop()
		if $scope.recording
			if $scope.media
				$scope.media.stopRecord()
				$scope.recording = undefined
		if $scope.media
			$scope.media.release()

	$scope.end = ()->
		$scope.stop()
		$location.path('/')

	$scope.edit = ()->
		$scope.stop()
		$location.path("edit/#{$scope.story.id}")

StoryController.$inject = [ '$scope','$location','$routeParams','$timeout']
