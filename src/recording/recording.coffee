module.exports = RecordingController = ($scope, $location,$timeout) ->

	$scope.play = (word)->
		filename = $scope.folderPath + "/#{word}.mp3"
		console.log "Playing: " + filename
		$scope.media = new Media(
			filename
			(success)->
				$scope.$apply ()->
					$scope.playing = undefined
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.playing = undefined
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.play()


	$scope.record = (word)->
		filename = $scope.folderPath + "/#{word}.mp3"
		$scope.stop()
		console.log "Recording: " + filename
		$scope.recording = word
		$scope.media = new Media(
			filename
			(success)->
				$scope.$apply ()->
					$scope.recording = undefined
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.recording = undefined
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.startRecord()

	$scope.continue = ()->
		$scope.stop()
		$scope.goto 'home'

	$scope.stop = ()->
		if $scope.playing
			if $scope.media
				$scope.media.stop()
				$scope.playing = undefined
		if $scope.recording
			if $scope.media
				$scope.media.stopRecord()
				$scope.recording = undefined

RecordingController.$inject = [ '$scope','$location','$timeout']
