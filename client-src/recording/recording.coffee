@RecordingController = ($scope, $location,$timeout) ->

	$scope.play = (word)->
		@stop()
		@playing = true
		$timeout(
			()=>
				@stop()
			,2000
		)
		# @media = new Media(src,
		# 	()-> console.log 'play audio success'
		# 	(e)-> console.log 'play audio error'+ e
		# 	(s)-> console.log 'play audio status: ' + s
		# )

	$scope.record = (word)->
		@stop()
		@recording = true
		$timeout(
			()=>
				@stop()
			,2000
		)
		# @media = new Media(src,
		# 	()-> console.log 'record audio success'
		# 	(e)-> console.log 'record audio error'+ e
		# 	(s)-> console.log 'record audio status: ' + s
		# )
		# @media.startRecord()

	$scope.stop = ()->
		@playing = false
		@recording = false

		# @media.stopRecord()

@RecordingController.$inject = [ '$scope','$location','$timeout']
