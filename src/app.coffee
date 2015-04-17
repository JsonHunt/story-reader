@isPhoneGap = document.URL.indexOf( 'http://' ) is -1 and document.URL.indexOf( 'https://' ) is -1

modules = [
	'ngRoute'
	'oc.modal'
	# 'ui.bootstrap'
	'ngMaterial'
	'ngTouch'
]

if @isPhoneGap
	modules.push 'ngCordova'

app = angular.module 'PublicApp', modules

app.controller 'IndexController', require './index-controller'
app.directive 'tap', require('./directives').tap
app.directive 'ngEnter', require('./directives').enter


app.config ['$httpProvider','$routeProvider', ($httpProvider,$routeProvider) ->

	$routeProvider.when '/',
		controller : require './home/home'
		templateUrl : 'home/home.html'
	.when '/story/:id/:opt?/:rec?',
		controller : require './story/story'
		templateUrl : 'story/story.html'
	.when '/edit/:id',
			controller : require './edit/edit'
			templateUrl : 'edit/edit.html'
	.when '/record',
			controller : require './recording/recording'
			templateUrl : 'recording/recording.html'
	.otherwise
		redirectTo : '/'
]

if @isPhoneGap
	console.log "PHONEGAP APPLICATION"
	document.addEventListener 'deviceready', ()->
		angular.bootstrap document, ['PublicApp']
	, false
else
	console.log "BROWSER"
	angular.bootstrap document, ['PublicApp']

module.exports = app
