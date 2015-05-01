service = require './../story-service'
storage = require './../storage-service'

# HomeController
module.exports = ['$scope','$rootScope', ($scope,$rootScope) ->
	# service.resetStories()
	$scope.allCaps = storage.loadInt 'allCaps'
	$scope.stories = service.getStories()

	$scope.select = (s)->
		$scope.goto("story/#{s.id}")
	$scope.remove = (s)-> service.removeStory s
	$scope.newStory = ()->
		$rootScope.openInEditMode = true
		$scope.select service.newStory("")

	$scope.toggleCaps = ()->
		$scope.capOn = !$scope.capOn
		storage.saveInt 'allCaps'
]
