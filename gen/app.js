// Generated by CoffeeScript 1.9.0
(function() {
  var app, modules;

  this.isPhoneGap = document.URL.indexOf('http://') === -1 && document.URL.indexOf('https://') === -1;

  modules = ['ngRoute', 'ngTouch', 'monospaced.elastic'];

  if (this.isPhoneGap) {
    modules.push('ngCordova');
  }

  app = angular.module('PublicApp', modules);

  app.controller('IndexController', require('./index-controller'));

  app.directive('tap', require('./directives').tap);

  app.directive('ngEnter', require('./directives').enter);

  app.config([
    '$httpProvider', '$routeProvider', function($httpProvider, $routeProvider) {
      return $routeProvider.when('/', {
        controller: require('./home/home'),
        templateUrl: 'home/home.html'
      }).when('/story/:id/:opt?/:rec?', {
        controller: require('./story/story'),
        templateUrl: 'story/story.html'
      }).when('/edit/:id', {
        controller: require('./edit/edit'),
        templateUrl: 'edit/edit.html'
      }).when('/record', {
        controller: require('./recording/recording'),
        templateUrl: 'recording/recording.html'
      }).otherwise({
        redirectTo: '/'
      });
    }
  ]);

  if (this.isPhoneGap) {
    console.log("PHONEGAP APPLICATION");
    document.addEventListener('deviceready', function() {
      return angular.bootstrap(document, ['PublicApp']);
    }, false);
  } else {
    console.log("BROWSER");
    angular.bootstrap(document, ['PublicApp']);
  }

  module.exports = app;

}).call(this);
