module.exports = RecordController = ($scope, $timeout,$cordovaMedia) ->

	setTimeout ()->
		$('.title').focus()
	,100

	# if not window.hasKBL
	window.addEventListener 'native.keyboardshow', (e)->
		$scope.$apply ()->
			$scope.keyboard = true
	window.addEventListener 'native.keyboardhide', (e)->
		$scope.$apply ()->
			$scope.keyboard = false
		# window.hasKBL = true

	$scope.rec = {}
	$scope.recording = false

	$scope.blur = ()->
		$('.title').blur()
		$timeout ()->
			$scope.allowRec = true
		,1000


	$scope.back = ()->
		if $scope.recording
			$scope.media.stopRecord()
		if $scope.playing
			$scope.media.stop()
		window.history.back()


	$scope.record = ()->
		$scope.recording = true
		$scope.mediaSource = $scope.rec.title + ".mp3"
		$scope.media = new Media(
			$scope.mediaSource
			(success)-> console.log "Success"
			(error)-> console.log JSON.stringify(error)
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.startRecord()

	$scope.stop = ()->
		if $scope.recording
			$scope.media.stopRecord()
			$scope.recording = false
			$scope.rec.url = $scope.mediaSource
		if $scope.playing
			$scope.media.stop()
			$scope.playing = false

	$scope.play = ()->
		$scope.media = new Media(
			$scope.mediaSource
			(success)->
				$scope.$apply ()->
					$scope.playing = false
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.playing = false
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.play()
		$scope.playing = true

	$scope.save = ()->
		title = $scope.rec.title
		if title is undefined or title.length is 0
			$scope.error = "Please enter a title"
			$('.title').focus()
			return

		$scope.recordings.push $scope.rec
		r = JSON.stringify($scope.recordings)
		window.localStorage.setItem 'recordings', r

		$scope.goto 'manage'

RecordController.$inject = [ '$scope','$timeout','$cordovaMedia' ]
