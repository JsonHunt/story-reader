module.exports = ['$scope', ($scope)->

	$scope.save = (key,item)->
		window.localStorage.setItem key, JSON.stringify(item)

	$scope.recordText = ()->
		$scope.recordingTitle = not $scope.recordingTitle
		if $scope.recordingTitle
			filename = "#{$scope.folderPath}/story-#{$scope.story.id}-title-recording.mp3"
			$scope.media = new Media(
				filename
				(success)->
					$scope.save "story-#{$scope.story.id}-title-recording", filename
					$scope.media.release()
				(error)->
					$scope.media.release()
			)
			$scope.media.startRecord()

			recognition = new SpeechRecognition()
			recognition.onresult = (event)->
				if event.results.length > 0
					console.log JSON.stringify(event.results,null,2)
					$scope.$apply ()->
						$scope.media.stopRecord()
						$scope.media.release()
						$scope.story.title = event.results[0][0].transcript
						$scope.save "story-#{$scope.story.id}", $scope.story

			recognition.start()
		else
			recognition.stop()

	$scope.onTitleKeyDown = (event)->
		console.log "KeyCode: #{event.keyCode}"

	$scope.onTitleChanged = ()->
		$scope.save "story-#{$scope.story.id}", $scope.story

	$scope.captureCoverImage = ()->

	$scope.googleCoverImage = ()->

	$scope.deleteCoverImage = ()->
]
