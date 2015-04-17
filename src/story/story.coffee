module.exports = StoryController = ($scope, $location, $routeParams, $timeout, $http, $cordovaFile) ->

	console.log $routeParams.id
	$scope.story = _.find $scope.stories, (s)-> parseInt(s.id) is parseInt($routeParams.id)
	console.log JSON.stringify($scope.story)
	$scope.story.sentences ?= []
	$scope.isEnd = $scope.sentenceIndex == $scope.story.sentences.length - 1
	$scope.isStart = true

	$scope.capOp = window.localStorage.getItem('caps')
	$scope.recOn = $routeParams.rec
	$scope.showOptions = $routeParams.opt

	punctuation = [',','...','!','?',';','.',':','"']

	appKey = "AIzaSyB83ol3E5p9fUSQPapia3TbwhAPVzLt2t8"
	engineKey = "015762953028935180710:bgwcqasc418"


	if $scope.story.sentences.length > 0
		$scope.sentenceIndex = 0
		$scope.sentence = $scope.story.sentences[0]

	# LOAD IMAGES
	wordsString = window.localStorage.getItem("wordImages")
	wordsString ?= JSON.stringify({})
	$scope.wordImages = JSON.parse(wordsString)

	$scope.toggleCaps = ()->
		$scope.stop()
		$scope.capOn = !$scope.capOn
		window.localStorage.setItem 'caps', $scope.capOn

	$scope.toggleRecording = ()->
		$scope.stop()
		$scope.closeImages()
		$scope.recOn = !$scope.recOn
		$scope.imgOn = false

	$scope.toggleImageSelect = ()->
		$scope.stop()
		$scope.closeImages()
		$scope.imgOn = !$scope.imgOn
		$scope.recOn = false

	$scope.select = (word)->
		return if _.contains punctuation, word
		if !$scope.recOn and !$scope.imgOn
			$scope.read word
		else if $scope.recOn
			if $scope.recording.toLowerCase() is word.toLowerCase()
				$scope.recordings[word.toLowerCase()] = true
				$scope.stop()
			else
				if $scope.recording
					$scope.recordings[$scope.recording.toLowerCase()] = true
				$scope.record word
		else if $scope.imgOn
			$scope.loadImagesFor word


	$scope.record = (word)->
		filename = $scope.folderPath + "/#{word}.mp3"
		$scope.stop()
		console.log "Recording: " + filename
		$timeout ()->
			$scope.recording = word.toLowerCase()
			$scope.media = new Media(
				filename
				(success)->
					$scope.$apply ()->
						$scope.recording = undefined
						$scope.recordings[word.toLowerCase()] = filename
						$scope.media.release()
				(error)->
					console.log JSON.stringify(error)
					$scope.$apply ()->
						$scope.recording = undefined
						$scope.media.release()
				(status)-> console.log JSON.stringify(status)
			)
			$scope.media.startRecord()
		,100

	$scope.read = (word) ->
		return if !$scope.folderPath
		$scope.stop()

		filename = $scope.folderPath + "/#{word}.mp3"
		console.log "Playing: " + filename
		$scope.playing = word.toLowerCase()
		$scope.media = new Media(
			filename
			(success)->
				$scope.$apply ()->
					if $scope.playing is word.toLowerCase()
						$scope.playing = undefined
						$scope.wordImageURL = undefined
						$scope.media.release()
			(error)->
				console.log JSON.stringify(error)
				$scope.$apply ()->
					$scope.playing = undefined
					$scope.wordImageURL = undefined
					$scope.media.release()
			(status)-> console.log JSON.stringify(status)
		)
		$scope.media.play()

		# SHOW RANDOM IMAGE ASSOCIATED WITH THE WORD
		images = $scope.wordImages[word]
		randomIndex = Math.floor(Math.random()*images.length)
		$scope.wordImageURL = "#{$scope.folderPath}/#{word}/#{randomIndex}"

	$scope.prevSentence = ()->
		return if @sentenceIndex is 0
		$scope.stop()
		@sentenceIndex--
		@sentence = @story.sentences[@sentenceIndex]

		@isStart = @sentenceIndex is 0
		@isEnd = @sentenceIndex == @story.sentences.length - 1

	$scope.nextSentence = ()->
		return if @sentenceIndex is @story.sentences.length-1
		$scope.stop()
		@sentenceIndex++
		@sentence = @story.sentences[@sentenceIndex]

		@isStart = false
		@isEnd = @sentenceIndex == @story.sentences.length - 1

	$scope.stop = ()->
		if $scope.playing
			$scope.playing = undefined
			if $scope.media
				$scope.media.stop()
		if $scope.recording
			if $scope.media
				$scope.media.stopRecord()
				$scope.recording = undefined
		if $scope.media
			$scope.media.release()

	$scope.end = ()->
		$scope.stop()
		$location.path('/')

	$scope.edit = ()->
		$scope.stop()
		$location.path("edit/#{$scope.story.id}")

	# IMAGES

	$scope.loadImagesFor = (word)->
		$scope.selectingImgFor = word.toLowerCase()
		$http.get "https://www.googleapis.com/customsearch/v1?key=#{appKey}&cx=#{engineKey}&searchType=image&q=#{word}"
		.error (data,status,headers,config)-> $scope.error = "Unable to get the images"
		.success (data,status,headers,config)->
			delete $scope.error
			$scope.imageResults = data.items
			console.log _.pluck($scope.imageResults, 'link')
			console.log _.pluck($scope.imageResults, 'thumbnailLink')
			console.log $scope.imageResults
			# console.log $scope.imageResults

	$scope.prevWord = ()->

	# $scope.nextWord = ()->
	# 	index = $scope.sentence.indexOf
	#
	# 	$scope.closeImages()


	$scope.prevImgResult = ()->

	$scope.nextImgResult = ()->

	$scope.toggleImage = (img)->
		return if !$scope.selectingImgFor
		$scope.saveFiles = true
		$scope.wordImages[$scope.selectingImgFor] ?= []
		images = $scope.wordImages[$scope.selectingImgFor]
		found = _.find images, (i)-> i is img.link
		if found
			$scope.wordImages[$scope.selectingImgFor] = _.without images,img.link
		else
			images.push img.link

		# $http.get imgUrl
		# .error (data,status,headers,config)-> console.log "Can't fetch #{imgUrl}"
		# .success (data,status,headers,config)->



	$scope.closeImages = ()->
		$scope.saveSelectedImages()
		$scope.selectingImgFor = false
		$scope.imageResults = []

	$scope.saveSelectedImages = ()->
		if !$scope.saveFiles or !$scope.selectingImgFor
			# SAVE FILES
			if $cordovaFile
				log "saving files"
				index = 0
				word = $scope.selectingImgFor
				path = "#{$scope.folderPath}/#{word}"
				$cordovaFile.createDir($scope.folderPath, word, true)
				.then(
					(error)-> return
					(success)->
						async.eachSeries $scope.wordImages[word], (imgUrl,next)->
							$scope.saveImage path,index,imgUrl,next
						, (err)-> console.log("All Done")
				)

		window.localStorage.setItem 'wordImages', JSON.stringify($scope.wordImages)
		$scope.saveFiles = false

	$scope.saveImage = (path, filename, imgUrl, callback)->
		$http.get imgUrl
		.error (data,status,headers,config)-> console.log(error); callback()
		.success (data,status,headers,config)->
			$cordovaFile.writeFile(path,filename,data,true).then(
				(success)-> console.log("Saved #{path}/#{filename}"); callback()
				(error)-> console.log(error); callback()
			)



	$scope.imageSelected = (img)-> return _.find  $scope.wordImages[$scope.selectingImgFor], (i)-> i is img.link



	$scope.getWordColor = (word)->
		if $scope.imgOn
			images = $scope.wordImages[word]
			if images and images.length > 0
				return 'green'

		if $scope.recOn and recordings[word.toLowerCase()]
			return 'green'

		return 'white'


services = [ '$scope','$location','$routeParams','$timeout','$http']

if @isPhoneGap
	services.push '$cordovaFile'

StoryController.$inject = services
