module.exports = ManageController = ($scope,$cordovaMedia) ->

	$scope.delete = (r,i)->
		if $scope.playing
			$scope.media.stop()
		$scope.recordings.splice i,1
		str = JSON.stringify($scope.recordings)
		window.localStorage.setItem 'recordings', str

	$scope.play = (rec,i)->
		if $scope.playing
			$scope.media.stop()
		console.log rec
		$scope.media = new Media(
			rec.url
			(success)->
				console.log "Success"
				$scope.$apply ()->
					$scope.playing = undefined
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.playing = undefined
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.play()
		$scope.playing = rec

	$scope.stop = ()->
		if $scope.playing
			$scope.media.stop()
			$scope.media.release()

	$scope.back = ()->
		if $scope.media and $scope.playing
			$scope.media.stop()
			$scope.media.release()
		window.history.back()

ManageController.$inject = [ '$scope','$cordovaMedia' ]
