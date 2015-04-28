storyService = require './../story-service'
mediaService = require './../media-service'

module.exports = StoryController = ($scope, $location, $routeParams, $timeout, $http, $cordovaFile, $cordovaFileTransfer, $cordovaCamera) ->
	# $scope.editController = require './../edit/edit'
	# $scope.readController = require './../read/read'

	console.log "Story ID: #{$routeParams.id}"
	storyService.selectStory parseInt($routeParams.id)

	$scope.pages = storyService.getPages()
	$scope.pageIndex = 0
	$scope.page = $scope.pages[0]
	$scope.mode = 'read'

	$scope.isStart = ()-> $scope.pageIndex is 0
	$scope.isEnd = ()-> $scope.pageIndex + 1 >= $scope.pages.length

	$scope.stopMedia = ()-> mediaService.stop()

	$scope.nextPage = ()->
		mediaService.stop()
		if not @isEnd()
			$scope.pageIndex++
			$scope.page = $scope.pages[$scope.pageIndex]

	$scope.prevPage = ()->
		mediaService.stop()
		if not @isStart()
			$scope.pageIndex--
			$scope.page = $scope.pages[$scope.pageIndex]

	$scope.home = ()->
		$scope.goto('')

	$scope.toggleOptions = ()->
		mediaService.stop()
		$scope.options = not $scope.options

	$scope.toggleEditPageText = ()->
		$scope.textEdit = not $scope.textEdit
		if $scope.textEdit
			setTimeout ()->
				$('#pagetext').focus()
			,50

	$scope.toggleEditMode = ()->
		if $scope.mode == 'edit'
			$scope.mode = 'read'
		else
			$scope.mode='edit'

	$scope.deletePage = ()->
		return if $scope.pages.length is 1
		storyService.removePage $scope.page.id
		$scope.confirmDeletePage = false
		if $scope.pageIndex >= $scope.pages.length
			$scope.pageIndex--
		$scope.page = $scope.pages[$scope.pageIndex]

	$scope.addPage = ()->
		pageNumber = $scope.pages.length + 1
		storyService.addPage "Page #{pageNumber}"
		$scope.nextPage()
		setTimeout ()->
			$('#pagetext').focus()
		,50

	$scope.savePage = ()->
		storyService.savePage $scope.page
		# $scope.saving = true
		# for wrd in $scope.page.words
		# 	if
		console.log "Page saved"
		$scope.textEdit = false

	$scope.googleImage = ()->
		$scope.imageSearch = true

	$scope.selectImage = ()->
		$scope.imageSearch = false

	# $scope.select = (word)->
	# 	return if _.contains $scope.punctuation, text
	# 	@word = storyService.getWord word
	# 	@wordImageURL = mediaService.getURL(@word.imagePath)
	# 	$scope.read(word) if not $scope.showOptions



	$scope.read = (word)->
		mediaService.stop()
		return if word is undefined
		if @reading is word
			delete reading

		else
			@reading = word
			mediaService.play @word.recordingPath, ()-> $scope.$apply ()-> delete $scope.word







	# $scope.recOn = $routeParams.rec


	# punctuation = [',','...','!','?',';','.',':','"']

	# appKey = "AIzaSyB83ol3E5p9fUSQPapia3TbwhAPVzLt2t8"
	# engineKey = "015762953028935180710:bgwcqasc418"

	# LOAD IMAGES
	# wordsString = window.localStorage.getItem("wordImages")
	# wordsString ?= JSON.stringify({})
	# $scope.wordImages = JSON.parse(wordsString)

	# simg = window.localStorage.getItem("sentenceImages")
	# simg ?= JSON.stringify({})
	# $scope.sentenceImages = JSON.parse(simg)

	# $scope.getSentenceImage = ()->
	# 	key = "#{$scope.story.id}-#{$scope.sentenceIndex}"
	# 	$scope.sentenceImageURL = $scope.sentenceImages[key]
	# 	console.log "Sentence image URL: #{$scope.sentenceImageURL}"

	# if $scope.story.sentences.length > 0
	# 	$scope.sentenceIndex = 0
	# 	$scope.sentence = $scope.story.sentences[0]
	# 	$scope.getSentenceImage()

	# $scope.toggleStoryEdit = ()-> $scope.editStory = !$scope.editStory; $scope.editPages = false
	# $scope.togglePagesEdit = ()-> $scope.editPages = !$scope.editPages; $scope.editStory = false
	#
	# $scope.toggleRecording = ()->
	# 	$scope.stop()
	# 	$scope.closeImages()
	# 	$scope.recOn = !$scope.recOn
	# 	$scope.imgOn = false
	#
	# $scope.toggleImageSelect = ()->
	# 	$scope.stop()
	# 	$scope.closeImages()
	# 	$scope.imgOn = !$scope.imgOn
	# 	$scope.recOn = false
	#
	# $scope.select = (word)->
	# 	return if _.contains punctuation, word
	# 	if !$scope.recOn and !$scope.imgOn
	# 		$scope.read word
	# 	else if $scope.recOn
	# 		if $scope.recording and $scope.recording.toLowerCase() is word.toLowerCase()
	# 			$scope.recordings[word.toLowerCase()] = true
	# 			$scope.stop()
	# 		else
	# 			if $scope.recording
	# 				$scope.recordings[$scope.recording.toLowerCase()] = true
	# 			$scope.record word
	# 	else if $scope.imgOn
	# 		$scope.wordQuery = word
	# 		$scope.loadImagesFor word
	#
	#
	# $scope.record = (word)->
	# 	filename = $scope.folderPath + "/#{word}.mp3"
	# 	$scope.stop()
	# 	console.log "Recording: " + filename
	# 	$timeout ()->
	# 		$scope.recording = word.toLowerCase()
	# 		$scope.media = new Media(
	# 			filename
	# 			(success)->
	# 				$scope.$apply ()->
	# 					$scope.recording = undefined
	# 					$scope.recordings[word.toLowerCase()] = filename
	# 					$scope.media.release()
	# 			(error)->
	# 				$scope.$apply ()->
	# 					$scope.recording = undefined
	# 					$scope.media.release()
	# 			# (status)-> console.log JSON.stringify(status)
	# 		)
	# 		$scope.media.startRecord()
	# 	,100
	#
	# $scope.read = (word) ->
	# 	return if !$scope.folderPath
	# 	$scope.stop()
	#
	# 	filename = $scope.folderPath + "/#{word}.mp3"
	# 	console.log "Playing: " + filename
	# 	$scope.playing = word.toLowerCase()
	# 	$scope.media = new Media(
	# 		filename
	# 		(success)->
	# 			$scope.$apply ()->
	# 				if $scope.playing is word.toLowerCase()
	# 					$scope.playing = undefined
	# 					$scope.wordImageURL = undefined
	# 					$scope.media.release()
	# 		(error)->
	# 			console.log JSON.stringify(error)
	# 			$scope.$apply ()->
	# 				$scope.playing = undefined
	# 				$scope.wordImageURL = undefined
	# 				$scope.media.release()
	# 		# (status)-> console.log JSON.stringify(status)
	# 	)
	# 	$scope.media.play()
	#
	# 	# SHOW RANDOM IMAGE ASSOCIATED WITH THE WORD
	# 	images = $scope.wordImages[word.toLowerCase()]
	# 	if images and images.length > 0
	# 		randomIndex = Math.floor(Math.random()*images.length)
	# 		$scope.wordImageURL = "#{$scope.folderPath}#{word}/#{randomIndex}"
	# 		# $cordovaFile.readAsDataURL("#{$scope.folderPath}#{word}", "#{randomIndex}")
	# 		# .then(
	# 		# 	(data)->
	# 		# 		log data
	# 		# 		document.getElementById("word-image").src = data
	# 		# 	(error) -> log error
	# 		# )
	#
	# 		# location = "#{$scope.folderPath}#{word}/#{randomIndex}"
	# 		# window.resolveLocalFileSystemURL location, (oFile)->
	# 		# 	oFile.file (readyFile)->
	# 		# 		reader= new FileReader()
	# 		# 		reader.onloadend= (evt)->
	# 		# 			document.getElementById("word-image").src = evt.target.result
	# 		# 		reader.readAsDataURL(readyFile)
	#
	# $scope.captureImage = ()->
	# 	if $scope.imgOn
	# 		options =
	# 			quality: 50
	# 			destinationType: Camera.DestinationType.FILE_URI
	# 			sourceType: Camera.PictureSourceType.CAMERA
	# 			allowEdit: true
	# 			encodingType: Camera.EncodingType.JPEG
	# 			targetWidth: 400
	# 			targetHeight: 400
	# 			popoverOptions: CameraPopoverOptions
	# 			saveToPhotoAlbum: false
	#
	# 		$cordovaCamera.getPicture(options).then(
	# 			(imageData)->
	# 				console.log "Picture taken in #{imageData}"
	# 				# filename = $scope.story.id + "-" + $scope.sentenceIndex
	# 				# $cordovaFile.writeFile($scope.folderPath,filename,imageData,true).then(
	# 				# 	(success)->
	# 				# 		console.log("Saved #{filename}")
	# 				# 		$scope.sentenceImageURL = "#{$scope.folderPath}#{$scope.story.id}-#{$scope.sentenceIndex}"
	# 				# 		console.log $scope.sentenceImageURL
	# 				# 	(error)-> log(error)
	# 				# )
	# 				#moveFile(cordova.file.externalCacheDirectory, file, newPath, newFile)
	# 				key = "#{$scope.story.id}-#{$scope.sentenceIndex}"
	# 				$scope.sentenceImages[key] = imageData
	# 				window.localStorage.setItem 'sentenceImages', JSON.stringify($scope.sentenceImages)
	# 				$scope.getSentenceImage()
	#
	# 			(error)-> log error
	# 		)
	#
	#
	#
	# $scope.prevSentence = ()->
	# 	return if @sentenceIndex is 0
	# 	$scope.stop()
	# 	@sentenceIndex--
	# 	@sentence = @story.sentences[@sentenceIndex]
	# 	$scope.getSentenceImage()
	#
	# 	@isStart = @sentenceIndex is 0
	# 	@isEnd = @sentenceIndex == @story.sentences.length - 1
	#
	# $scope.nextSentence = ()->
	# 	return if @sentenceIndex is @story.sentences.length-1
	# 	$scope.stop()
	# 	@sentenceIndex++
	# 	@sentence = @story.sentences[@sentenceIndex]
	# 	$scope.getSentenceImage()
	#
	# 	@isStart = false
	# 	@isEnd = @sentenceIndex == @story.sentences.length - 1
	#
	# $scope.stop = ()->
	# 	if $scope.playing
	# 		$scope.playing = undefined
	# 		if $scope.media
	# 			$scope.media.stop()
	# 	if $scope.recording
	# 		if $scope.media
	# 			$scope.media.stopRecord()
	# 			$scope.recording = undefined
	# 	if $scope.media
	# 		$scope.media.release()
	#
	# $scope.end = ()->
	# 	$scope.stop()
	# 	$location.path('/')
	#
	# $scope.edit = ()->
	# 	$scope.stop()
	# 	$location.path("edit/#{$scope.story.id}")
	#
	# # IMAGES
	#
	# $scope.removeSentenceImage = ()->
	#
	# $scope.enableSentenceImageSearch = ()->
	#
	# $scope.captureSentenceImage = ()->
	#
	#
	# $scope.refreshWordImageResults = ()-> $scope.loadImagesFor $scope.selectingImgFor
	#
	# $scope.loadImagesFor = (word)->
	# 	$scope.selectingImgFor = word.toLowerCase()
	# 	$http.get "https://www.googleapis.com/customsearch/v1?key=#{appKey}&cx=#{engineKey}&searchType=image&safe=medium&imgSize=medium&q=#{$scope.wordQuery}"
	# 	.error (data,status,headers,config)-> $scope.error = "Unable to get the images"
	# 	.success (data,status,headers,config)->
	# 		delete $scope.error
	# 		$scope.imageResults = data.items
	# 		console.log _.pluck($scope.imageResults, 'link')
	# 		console.log _.pluck($scope.imageResults, 'thumbnailLink')
	# 		console.log $scope.imageResults
	# 		# console.log $scope.imageResults
	#
	# $scope.prevWord = ()->
	#
	# # $scope.nextWord = ()->
	# # 	index = $scope.sentence.indexOf
	# #
	# # 	$scope.closeImages()
	#
	#
	# $scope.prevImgResult = ()->
	#
	# $scope.nextImgResult = ()->
	#
	# $scope.addWordImage = (img)->
	# 	return if !$scope.selectingImgFor
	# 	$scope.saveFiles = true
	# 	$scope.wordImages[$scope.selectingImgFor] ?= []
	# 	images = $scope.wordImages[$scope.selectingImgFor]
	# 	found = _.find images, (i)-> i is img.link
	# 	if found is undefined
	# 		console.log "Adding image #{img.link}"
	# 		images.push img.link
	#
	# $scope.removeWordImage = (img)->
	# 	return if !$scope.selectingImgFor
	# 	$scope.saveFiles = true
	# 	$scope.wordImages[$scope.selectingImgFor] ?= []
	# 	images = $scope.wordImages[$scope.selectingImgFor]
	# 	found = _.find images, (i)-> i is img.link
	# 	if found
	# 		console.log "Removing image #{img.link}"
	# 		$scope.wordImages[$scope.selectingImgFor] = _.without images,img.link
	#
	# $scope.closeImages = ()->
	# 	$scope.saveSelectedImages()
	# 	$scope.selectingImgFor = false
	# 	$scope.imageResults = []
	#
	# log = (err)->
	# 	console.log JSON.stringify(err,null,2)
	#
	# $scope.saveSelectedImages = ()->
	# 	return if !$scope.saveFiles
	# 	return if !$scope.selectingImgFor
	# 	word = $scope.selectingImgFor
	# 	return if !$scope.wordImages[word] or $scope.wordImages[word].length is 0
	# 	# SAVE FILES
	# 	if $cordovaFile
	# 		console.log  "saving #{$scope.wordImages[word].length} files"
	# 		index = 0
	# 		word = $scope.selectingImgFor
	#
	# 		saveThem = ()->
	# 			async.eachSeries $scope.wordImages[word], (imgUrl,next)->
	# 				$scope.saveImage word,index,imgUrl,()-> index++; next()
	# 			, (err)-> console.log("All Done")
	#
	# 		$cordovaFile.createDir($scope.folderPath, word, true)
	# 		.then(
	# 			(success)-> saveThem()
	# 			(error)-> saveThem()
	# 		)
	#
	# 	window.localStorage.setItem 'wordImages', JSON.stringify($scope.wordImages)
	# 	$scope.saveFiles = false
	#
	# $scope.saveImage = (path, filename, imgUrl, callback)->
	# 	localPath = "#{$scope.folderPath}#{path}/#{filename}"
	# 	$cordovaFileTransfer.download(imgUrl, localPath, {}, true).then(
	# 		(success)-> console.log "Downloaded #{imgUrl}"; callback()
	# 		(error)-> log(error); callback()
	# 	)
	# 	# $http.get imgUrl
	#
	#
	# 		# fullFilename = "#{path}/#{filename}"
	# 		# $cordovaFile.writeFile($scope.folderPath,fullFilename,data,true).then(
	# 		# 	(success)-> console.log("Saved #{path}/#{filename}"); callback()
	# 		# 	(error)-> log(error); callback()
	# 		# )
	#
	#
	#
	# $scope.imageSelected = (img)-> return _.find  $scope.wordImages[$scope.selectingImgFor], (i)-> i is img.link
	#
	#
	#
	# $scope.getWordColor = (word)->
	# 	if $scope.imgOn
	# 		images = $scope.wordImages[word.toLowerCase()]
	# 		if images and images.length > 0
	# 			return 'green'
	#
	# 	if $scope.recOn and @recordings[word.toLowerCase()]
	# 		return 'green'
	#
	# 	return 'white'


services = [ '$scope','$location','$routeParams','$timeout','$http']

if @isPhoneGap
	services.push '$cordovaFile'
	services.push '$cordovaFileTransfer'
	services.push '$cordovaCamera'

StoryController.$inject = services
