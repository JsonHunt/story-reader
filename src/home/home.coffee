module.exports = HomeController = ($scope) ->

	$scope.selectStory = (s)->
		$scope.goto("story?id=#{s.id}")

	$scope.newStory = ()->
		$scope.goto("edit/0")

HomeController.$inject = [ '$scope' ]
