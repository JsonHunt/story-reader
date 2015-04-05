module.exports = SessionController = ($scope,$timeout,$interval) ->

	window.addEventListener "batterystatus", (info)->
		$scope.$apply ()->
			$scope.notcharging = !info.isPlugged
	, false

	$scope.delays = [30,40,50,60,120,180]
	$scope.durations = [1,2,3,4,5,6]

	$scope.duration = window.localStorage.getItem 'duration'
	$scope.delay = window.localStorage.getItem 'delay'

	$scope.delay ?= 60
	$scope.duration ?= 6
	$scope.volumeInterval = 10

	$scope.setDuration = (d)->
		$scope.duration = d
		window.localStorage.setItem 'duration', d

	$scope.setDelay = (d)->
		$scope.delay = d
		window.localStorage.setItem 'delay', d

	# $scope.back = ()-> $scope.goto('home')

	$scope.start = ()->
		$scope.playing = true
		$scope.currentRec = 0
		$scope.currentVolume = 0.01

		$scope.delayTimer = $timeout ()->
			$scope.play()
			# $scope.volumeTimer = $interval($scope.volumeUp,2000)
			$scope.volumeTimer = $interval $scope.volumeUp,$scope.volumeInterval*60*1000

			$scope.stopTimer = $timeout ()->
				$scope.stop()
				$scope.goto('home')
			, $scope.duration*360*1000
		, $scope.delay*60*1000
		# , 5000

	$scope.play = ()->
		console.log "Playing next recording"
		return if not $scope.playing
		if $scope.currentRec >= $scope.recordings.length
			$scope.currentRec = 0
		rec = $scope.recordings[$scope.currentRec]
		$scope.media = new Media(
			rec.url
			(success)->
				console.log "Success"
				$scope.$apply ()->
					$scope.currentRec++
					$scope.media.release()
					$scope.play()
			(error)->
				console.log "Play error, " + error.toString()
				$scope.$apply ()->
					$scope.playing = false
					$scope.media.release()
			(status)-> console.log status.toString()
		)
		$scope.media.setVolume $scope.currentVolume
		$scope.media.play()

	$scope.back = ()->
		if $scope.playing
			$scope.stop()
		window.history.back()

	$scope.stop = ()->
		if $scope.playing
			if $scope.media
				$scope.media.stop()
				$scope.media.release()
			$scope.playing = false
			$scope.currentRec = 0
			$interval.cancel($scope.volumeTimer)
			$timeout.cancel($scope.delayTimer)

	$scope.volumeUp = ()->
		if $scope.media and $scope.playing and $scope.currentVolume < 1
			$scope.currentVolume += 0.05
			if $scope.currentVolume > 1
				$scope.currentVolume = 1
			$scope.media.setVolume $scope.currentVolume



SessionController.$inject = [ '$scope','$timeout','$interval' ]
