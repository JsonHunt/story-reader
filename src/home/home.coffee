module.exports = HomeController = ($scope) ->

	$scope.capOn = window.localStorage.getItem('caps')

	stories = $scope.loadArray('stories')

	$scope.getTitle = (s)->
		pages = $scope.load "story-pages-#{s}"
		return pages[0].text

	$scope.selectStory = (s)->
		$scope.goto("story/#{s.id}")

	$scope.newStory = ()->
		newStory = $scope.getNextID()
		$scope.stories.push newStory
		$scope.save 'stories', $scope.stories

		titlePage =
			id: $scope.getNextID()
			text: "New Story"
		$scope.save "story-pages-#{newStory}", [titlePage]
		# $scope.goto "story/#{storyID}"

	$scope.toggleCaps = ()->
		$scope.capOn = !$scope.capOn
		window.localStorage.setItem 'caps', $scope.capOn

	$scope.delete = (s)->
		for id,index in $scope.stories
			if id is s
				$scope.stories.splice index,1

				break
		$scope.save 'stories', $scope.stories


HomeController.$inject = [ '$scope' ]
