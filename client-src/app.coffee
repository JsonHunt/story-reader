app = angular.module('storyReader', [ 'ngRoute' ]).run ()->
	FastClick.attach(document.body)

app.controller 'RootController', RootController
app.controller 'MainController', MainController
app.controller 'StoryController', StoryController
app.controller 'EditController', EditController
app.controller 'RecordingController', RecordingController

app.config([ '$routeProvider', ($routeProvider) ->
	$routeProvider.when('/', {
		controller : 'MainController',
		templateUrl : 'main/main.html'
	}).when('/story/:id', {
		controller : 'StoryController'
		templateUrl : 'story/story.html'
	}).when('/edit/:id', {
		controller : 'EditController'
		templateUrl : 'edit/edit.html'
	}).when('/recording', {
		controller : 'RecordingController'
		templateUrl : 'recording/recording.html'
	}).otherwise({
		redirectTo : '/'
	})
 ])
