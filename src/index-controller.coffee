module.exports = IndexController = ($scope,$location, $cordovaFile) ->

	$scope.save = (key,value)->
		window.localStorage.setItem key, JSON.stringify(value)

	$scope.saveInt = (key,value)->
		window.localStorage.setItem key, value

	$scope.load = (key)->
		value = window.localStorage.getItem(key)
		return {} if value is undefined
		return JSON.parse(value)

	$scope.loadArray = (key)->
		value = window.localStorage.getItem(key)
		return [] if value is undefined
		return JSON.parse(value)

	$scope.loadInt = (key)->
		value = window.localStorage.getItem(key)
		return 0 if value is undefined
		return parseInt(value)

	$scope.getNextID = ()->
		nextID = $scope.loadInt('nextID')
		$scope.saveInt 'nextID', nextID+1
		return nextID

	# storiesString = window.localStorage.getItem("stories")
	# storiesString ?= JSON.stringify([])
	# $scope.stories = JSON.parse(storiesString)
	# $scope.stories = _.filter $scope.stories, (s) -> s.id

	console.log JSON.stringify($scope.stories)

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

	if $cordovaFile
		$cordovaFile
		.checkDir cordova.file.externalDataDirectory, "story-reader-files"
		.then (success)->
			# console.log "story-reader-files folder exists"
			$scope.checkFiles()
		,(error)->
			if error.message is 'NOT_FOUND_ERR'
				$cordovaFile
				.createDir cordova.file.externalDataDirectory, "story-reader-files"
				.then (success)->
					# console.log "Created story-reader-files folder"
					$scope.checkFiles()
				, (error)->
					console.log "Error: #{error}"
			else
				console.log "Error checking for recording directory : " + JSON.stringify(error)

	$scope.recordings = {}
	$scope.checkFiles = ()->
		window.resolveLocalFileSystemURL cordova.file.externalDataDirectory + 'story-reader-files', (fileEntry)->
			$scope.folderPath = fileEntry.toURL()
			# console.log "Folder path : #{$scope.folderPath}"
			async.each $scope.allWords, (w,cb)->
				path = "story-reader-files/#{w}.mp3"
				$cordovaFile
				.checkFile cordova.file.externalDataDirectory, path
				.then (success)->
					# console.log "Found file: " + JSON.stringify(success)
					$scope.recordings[w.toLowerCase()] = success
					cb()
				, (error)-> cb()
			, (err)->
				console.log err if err
				# console.log "Checked all words"

		, (error)->
			console.log "Error getting folder URL : " + JSON.stringify(error)


if @isPhoneGap
	IndexController.$inject = [ '$scope','$location','$cordovaFile']
else
	IndexController.$inject = [ '$scope','$location' ]
