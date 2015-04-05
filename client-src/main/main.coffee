@MainController = ($scope, $location) ->

	$scope.newStory = ()->
		story =
			id: @stories.length
			title: 'Title'
			text: ''

		$scope.stories.push story
		window.localStorage.setItem 'stories', JSON.stringify($scope.stories)
		$location.path('edit/' + story.id)

	$scope.select = (story)->
		$location.path('story/'+ story.id)

@MainController.$inject = [ '$scope','$location']
