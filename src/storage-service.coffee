class StorageService

	resetID: ()-> saveInt 'nextID', 0

	getNextID: ()->
		nextID = @loadInt('nextID')
		@saveInt 'nextID', nextID+1
		return nextID

	save: (key,value)->
		window.localStorage.setItem key, JSON.stringify(value)

	saveInt: (key,value)->
		window.localStorage.setItem key, value

	remove: (key)->
		window.localStorage.removeItem key

	load: (key)->
		value = window.localStorage.getItem(key)
		return {} if value is null
		return JSON.parse(value)

	loadArray: (key)->
		value = window.localStorage.getItem(key)
		return [] if value is null
		return JSON.parse(value)

	loadInt: (key)->
		value = window.localStorage.getItem(key)
		return 0 if value is null
		return parseInt(value)

module.exports = new StorageService()
