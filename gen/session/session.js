// Generated by CoffeeScript 1.9.0
(function() {
  var SessionController;

  module.exports = SessionController = function($scope, $timeout, $interval) {
    window.addEventListener("batterystatus", function(info) {
      return $scope.$apply(function() {
        return $scope.notcharging = !info.isPlugged;
      });
    }, false);
    $scope.delays = [30, 40, 50, 60, 120, 180];
    $scope.durations = [1, 2, 3, 4, 5, 6];
    $scope.duration = window.localStorage.getItem('duration');
    $scope.delay = window.localStorage.getItem('delay');
    if ($scope.delay == null) {
      $scope.delay = 60;
    }
    if ($scope.duration == null) {
      $scope.duration = 6;
    }
    $scope.volumeInterval = 10;
    $scope.setDuration = function(d) {
      $scope.duration = d;
      return window.localStorage.setItem('duration', d);
    };
    $scope.setDelay = function(d) {
      $scope.delay = d;
      return window.localStorage.setItem('delay', d);
    };
    $scope.start = function() {
      $scope.playing = true;
      $scope.currentRec = 0;
      $scope.currentVolume = 0.01;
      return $scope.delayTimer = $timeout(function() {
        $scope.play();
        $scope.volumeTimer = $interval($scope.volumeUp, $scope.volumeInterval * 60 * 1000);
        return $scope.stopTimer = $timeout(function() {
          $scope.stop();
          return $scope.goto('home');
        }, $scope.duration * 360 * 1000);
      }, $scope.delay * 60 * 1000);
    };
    $scope.play = function() {
      var rec;
      console.log("Playing next recording");
      if (!$scope.playing) {
        return;
      }
      if ($scope.currentRec >= $scope.recordings.length) {
        $scope.currentRec = 0;
      }
      rec = $scope.recordings[$scope.currentRec];
      $scope.media = new Media(rec.url, function(success) {
        console.log("Success");
        return $scope.$apply(function() {
          $scope.currentRec++;
          $scope.media.release();
          return $scope.play();
        });
      }, function(error) {
        console.log("Play error, " + error.toString());
        return $scope.$apply(function() {
          $scope.playing = false;
          return $scope.media.release();
        });
      }, function(status) {
        return console.log(status.toString());
      });
      $scope.media.setVolume($scope.currentVolume);
      return $scope.media.play();
    };
    $scope.back = function() {
      if ($scope.playing) {
        $scope.stop();
      }
      return window.history.back();
    };
    $scope.stop = function() {
      if ($scope.playing) {
        if ($scope.media) {
          $scope.media.stop();
          $scope.media.release();
        }
        $scope.playing = false;
        $scope.currentRec = 0;
        $interval.cancel($scope.volumeTimer);
        return $timeout.cancel($scope.delayTimer);
      }
    };
    return $scope.volumeUp = function() {
      if ($scope.media && $scope.playing && $scope.currentVolume < 1) {
        $scope.currentVolume += 0.05;
        if ($scope.currentVolume > 1) {
          $scope.currentVolume = 1;
        }
        return $scope.media.setVolume($scope.currentVolume);
      }
    };
  };

  SessionController.$inject = ['$scope', '$timeout', '$interval'];

}).call(this);
