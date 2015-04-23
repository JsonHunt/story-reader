module.exports = ['$scope',($scope)->

	$scope.pageIndex = 0
	punctuation = ['(',')',',','...','!','?',';','.',':','"']

	$scope.nextPage = ()->
		if $scope.pageIndex < $scope.story.pages -1
			$scope.pageIndex++
			$scope.showPage()

	$scope.prevPage = ()->
		if $scope.pageIndex > 0
			$scope.pageIndex--
			$scope.showPage()

	$scope.showPage = ()->
		$scope.pageIndex = 0 if $scope.pageIndex is undefined
		text = $scope.story.pages[$scope.pageIndex].text
		for p in punctuation
			text = S(text).replaceAll(p," #{p} ").s
		text = S(text).collapseWhitespace().s
		$scope.words = text.split(" ")	
]
