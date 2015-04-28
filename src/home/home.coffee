service = require './../story-service'
storage = require './../storage-service'

# HomeController
module.exports = ['$scope', ($scope) ->
	# service.resetStories()
	$scope.allCaps = storage.loadInt 'allCaps'
	$scope.stories = service.getStories()

	$scope.select = (s)-> $scope.goto("story/#{s.id}")
	$scope.remove = (s)-> service.removeStory s
	$scope.newStory = ()-> $scope.select service.newStory("New Story")

	$scope.toggleCaps = ()->
		$scope.capOn = !$scope.capOn
		storage.saveInt 'allCaps'
]
