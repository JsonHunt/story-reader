class ImageSearchService
	appKey: "AIzaSyB83ol3E5p9fUSQPapia3TbwhAPVzLt2t8"
	engineKey: "015762953028935180710:bgwcqasc418"

	initialize: (http,cordovaFileT)=>
		@http = http
		@cordovaFileT = cordovaFileT
		console.log "Cordova file transfer is: " + @cordovaFileT

	findImagesFor: (query, callback)=>
		key = "key=#{@appKey}"
		engine = "cx=#{@engineKey}"
		type = "searchType=image"
		safety = "safe=medium"
		size = "imgSize=medium"
		query = "q=#{query}"

		url = "https://www.googleapis.com/customsearch/v1?#{key}&#{engine}&#{type}&#{safety}&#{size}&#{query}"
		@http.get url
			.error (data,status,headers,config)->
				# console.log "Image search error: #{data}"
				callback data
			.success (data,status,headers,config)->
				# console.log "Image search results: "
				# console.log JSON.stringify data.items, null,2
				callback undefined, data.items
		# 		console.log _.pluck($scope.imageResults, 'link')
		# 		console.log _.pluck($scope.imageResults, 'thumbnailLink')

	saveImage: (url, filename, callback)=>
		targetPath = cordova.file.externalDataDirectory + filename;
		console.log "SAVING IMAGE TO #{targetPath}"
		trustHosts = true
		options = {};
		@cordovaFileT.download(url, targetPath, options, trustHosts).then(
			(result)->
				console.log "SAVED IMAGE TO #{targetPath}"
				callback(targetPath)
			(error)->
				console.log "ERROR: " + JSON.stringify(error,null,2)
				callback()
		)

module.exports = new ImageSearchService()
