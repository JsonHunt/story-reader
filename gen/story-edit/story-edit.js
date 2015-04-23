// Generated by CoffeeScript 1.9.0
(function() {
  module.exports = [
    '$scope', function($scope) {
      $scope.save = function(key, item) {
        return window.localStorage.setItem(key, JSON.stringify(item));
      };
      $scope.recordText = function() {
        var filename, recognition;
        $scope.recordingTitle = !$scope.recordingTitle;
        if ($scope.recordingTitle) {
          filename = $scope.folderPath + "/story-" + $scope.story.id + "-title-recording.mp3";
          $scope.media = new Media(filename, function(success) {
            $scope.save("story-" + $scope.story.id + "-title-recording", filename);
            return $scope.media.release();
          }, function(error) {
            return $scope.media.release();
          });
          $scope.media.startRecord();
          recognition = new SpeechRecognition();
          recognition.onresult = function(event) {
            if (event.results.length > 0) {
              console.log(JSON.stringify(event.results, null, 2));
              return $scope.$apply(function() {
                $scope.media.stopRecord();
                $scope.media.release();
                $scope.story.title = event.results[0][0].transcript;
                return $scope.save("story-" + $scope.story.id, $scope.story);
              });
            }
          };
          return recognition.start();
        } else {
          return recognition.stop();
        }
      };
      $scope.onTitleKeyDown = function(event) {
        return console.log("KeyCode: " + event.keyCode);
      };
      $scope.onTitleChanged = function() {
        return $scope.save("story-" + $scope.story.id, $scope.story);
      };
      $scope.captureCoverImage = function() {};
      $scope.googleCoverImage = function() {};
      return $scope.deleteCoverImage = function() {};
    }
  ];

}).call(this);
