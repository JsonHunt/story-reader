class FileService

	initialize: (fileService, callback)=>
		return if cordova is undefined
		@cordovaFileT = fileService
		window.resolveLocalFileSystemURL cordova.file.externalDataDirectory, (fileEntry)=>
			@root = fileEntry.toURL()
			callback() if callback

	getURL: (filename)->
		if !root
			console.log "File service was not initialized"
		else
			return "#{@root}/#{filename}"

	downloadFile: (url, filename, callback)=>
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

module.exports = new FileService()
