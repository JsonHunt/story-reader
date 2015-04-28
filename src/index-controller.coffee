fileService = require './file-service'

module.exports = IndexController = ($scope,$location, $cordovaFile) ->

	fileService.initialize()

	$scope.appTitle = "Story Reader"
	$scope.punctuation = ['(',')',',','...','!','?',';','.',':','"']

	# storiesString = window.localStorage.getItem("stories")
	# storiesString ?= JSON.stringify([])
	# $scope.stories = JSON.parse(storiesString)
	# $scope.stories = _.filter $scope.stories, (s) -> s.id

	$scope.log = (toLog)->
		console.log JSON.stringify(toLog,null,2)

	wordsString = window.localStorage.getItem("words")
	wordsString ?= JSON.stringify([])
	$scope.allWords = JSON.parse(wordsString)

	window.addEventListener 'native.keyboardshow', (e)->
		$scope.$apply ()->
			$scope.keyboard = true
	window.addEventListener 'native.keyboardhide', (e)->
		$scope.$apply ()->
			$scope.keyboard = false

	$scope.goto = (path)->
		$location.path(path)

	$scope.back = ()->
		window.history.back()




if @isPhoneGap
	IndexController.$inject = [ '$scope','$location','$cordovaFile']
else
	IndexController.$inject = [ '$scope','$location' ]
