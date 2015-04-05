storyParser = require './story-parser'

module.exports = EditController = ($scope, $location, $routeParams,$timeout) ->

	$('input.title').hide()
	$('.story').hide()

	setTimeout ()->
		$('input.title').show()
		$('.story').show()
		# $('input.title').blur()
	,50

	id = parseInt $routeParams.id
	if id isnt 0
		$scope.story = _.find $scope.stories, (s)-> parseInt(s.id) is id
		if !$scope.story
			goto 'home'
			return
	else
		lastID = window.localStorage.getItem 'lastID'
		lastID ?= 0
		$scope.story =
			id: parseInt(lastID)+1

	console.log "STORY ID: #{$scope.story.id}"

	$scope.titleEnter = ()->
		$('.story').focus()

	$scope.textEnter = ()->
		$('.story').blur()

	$scope.save = ()->
		title = $scope.story.title
		if !title or title.length is 0
			$scope.error = "Title is required"
			return
		else
			titlearr = title.split ' '
			title = ''
			for w in titlearr
				title += S(w).capitalize().s + " "

			$scope.story.id = parseInt($scope.story.id)
			$scope.story.title = S(title).trim().s

		text = $scope.story.text
		if !text or text.length is 0
			$scope.error = "Story is too short!"
			return

		result = storyParser.parse($scope.story.text)
		$scope.story.sentences = result.sentences

		text = ''
		for s in result.sentences
			for w in s.words
				text += w + ' '
		$scope.story.text = text

		if id is 0
			$scope.stories.push $scope.story

		$scope.allWords = _.union $scope.allWords, result.words

		window.localStorage.setItem 'stories', JSON.stringify($scope.stories)
		window.localStorage.setItem 'words', JSON.stringify($scope.allWords)
		window.localStorage.setItem 'lastID', $scope.story.id
		$location.path "story/#{$scope.story.id}/1/1"

	$scope.delete = ()->
		id = parseInt $routeParams.id
		if id is 0
			$scope.goto 'home'
			return

		for s,i in $scope.stories
			if s.id is $scope.story.id
				$scope.stories.splice i,1
				window.localStorage.setItem 'stories', JSON.stringify($scope.stories)
				break

		$timeout ()->
			$scope.goto 'home'
		,100


EditController.$inject = [ '$scope','$location', '$routeParams','$timeout']
