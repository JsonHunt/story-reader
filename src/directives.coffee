exports.tap = ($timeout) ->
	{
		restrict: 'A'
		# priority: -1
		link: (scope, elem, attr) ->
			elem.on 'touchend', (event)->
				return if cooldown
				cooldown = true
				if @isPhoneGap and window.plugins?.deviceFeedback?.acoustic
					window.plugins.deviceFeedback.acoustic()
				$timeout ()->
					scope.$apply ()->
						elem.removeClass 'touched'
						cooldown = false
				,100

				scope.$apply ()->
					elem.addClass 'touched'
					scope.$eval attr.tap
	}

exports.enter = ()->
		(scope, element, attrs)->
			element.bind "keyup", (event)->
				if event.which is 13
					scope.$apply ()->
						scope.$eval attrs.ngEnter
					event.preventDefault()
