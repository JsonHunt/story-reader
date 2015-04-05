exports.tap = ($timeout) ->
	{
		restrict: 'A'
		# priority: -1
		link: (scope, elem, attr) ->
			elem.on 'touchend', (event)->
				if window.plugins?.deviceFeedback?.acoustic
					window.plugins.deviceFeedback.acoustic()
				scope.$apply ()->
					scope.$eval attr.tap
	}

exports.enter = ()->
		(scope, element, attrs)->
			element.bind "keyup", (event)->
				if event.which is 13
					scope.$apply ()->
						scope.$eval attrs.ngEnter
					event.preventDefault()
