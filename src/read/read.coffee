storyService = require './../story-service'
mediaService = require './../media-service'
wordService =
	getWord: (text)-> return undefined

module.exports = ['$scope',($scope)->

	$scope.read = (text)->
		return if _.contains $scope.punctuation, text
		@word = storyService.getWord text
		if @word is undefined
			@word = wordService.getWord text
		if @word
			mediaService.play @word.recordingPath, ()-> $scope.$apply ()-> delete $scope.word

		@reading = text
		@wordImageURL = mediaService.getURL(@word.imagePath)

	$scope.closeImage = ()-> delete @wordImageURL
]
