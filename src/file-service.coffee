class FileService

	initialize: (callback)=>
		return if cordova is undefined
		window.resolveLocalFileSystemURL cordova.file.externalDataDirectory, (fileEntry)=>
			@root = fileEntry.toURL()
			callback() if callback

	getURL: (filename)->
		if !root
			console.log "File service was not initialized"
		else
			return "#{@root}/#{filename}"

module.exports = new FileService()
