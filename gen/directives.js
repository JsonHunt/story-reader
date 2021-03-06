// Generated by CoffeeScript 1.9.0
(function() {
  exports.tap = function($timeout) {
    return {
      restrict: 'A',
      link: function(scope, elem, attr) {
        return elem.on('touchend', function(event) {
          var cooldown, _ref, _ref1;
          if (cooldown) {
            return;
          }
          cooldown = true;
          if (this.isPhoneGap && ((_ref = window.plugins) != null ? (_ref1 = _ref.deviceFeedback) != null ? _ref1.acoustic : void 0 : void 0)) {
            window.plugins.deviceFeedback.acoustic();
          }
          return $timeout(function() {
            return scope.$apply(function() {
              elem.removeClass('tapped');
              cooldown = false;
              elem.addClass('tapped');
              return scope.$eval(attr.tap);
            });
          }, 100);
        });
      }
    };
  };

  exports.enter = function() {
    return function(scope, element, attrs) {
      return element.bind("keyup", function(event) {
        if (event.which === 13) {
          scope.$apply(function() {
            return scope.$eval(attrs.ngEnter);
          });
          return event.preventDefault();
        }
      });
    };
  };

}).call(this);
