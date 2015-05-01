fileService = require './file-service'

class MediaService

	getURL: (path)-> fileService.getURL(path)

	play: (path,callback)=>
		url = path #fileService.getURL(path)
		# done = ()=>
		# 	# @stop()
		# 	callback()
		@media = new Media(url, callback, callback)
		@media.play()
		@playing = path

	record: (path)=>
		url = fileService.getURL(path)
		done = ()=>
			@stop()
			callback()
		@media = new Media(url, done, done)
		@media.startRecord()
		@recording = path

	stop: ()->
		if @listening
			@recognition.stop()
			delete @listening
		if @media
			if @playing
				@media.stop()
				delete @playing
			if @recording
				@media.stopRecord()
				delete @recording
			@media.release()
			delete @media

	listen: (continuous, callback)->
		try
			@stop()
			@recognition = new SpeechRecognition()
			@recognition.continuous = true
			@listening = true
			@lastResult = ""
			@recognition.onresult = (event)=>
				# console.log JSON.stringify event,null,2
				result = event.results[0][0].transcript
				console.log "Result: #{result}"
				newResult = result.substr @lastResult.length
				@lastResult = result
				callback newResult
				# @recognition.start()
			@recognition.onend = (event)-> console.log "ended"
			@recognition.onnomatch = (event)-> console.log "no match"

			@recognition.start()
		catch e
			console.log e

module.exports = new MediaService()
