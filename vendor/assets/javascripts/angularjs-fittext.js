var module = angular.module('fitText', []);

module.directive('fittext', [ '$window', '$document', function( $window, $document ) {
  return {
    restrict: 'A',
    scope: {
      watch: '=',
      compressor: '@'
    },
    link: function( $scope, $element, $attrs ) {

      $scope.compressor = 0.85;
      $scope.minFontSize = $attrs.min || Number.NEGATIVE_INFINITY;
      $scope.maxFontSize = $attrs.max || Number.POSITIVE_INFINITY;

      var resizer = function() {

        console.log("resizer", $scope.compressor);
        $scope.fontSize = Math.max(
          Math.min(
            $element[0].offsetWidth / ( $scope.compressor * 10 ),
            parseFloat( $scope.maxFontSize )
        ),
        parseFloat( $scope.minFontSize )
        ) + 'px';
        console.log($element[0].offsetWidth);
        console.log($scope.fontSize);
        $element.css('font-size', $scope.fontSize);
      };

      $scope.$watch('watch', function(newValue, oldValue) {
        $scope.compressor = $attrs.compressor || 1;
        $scope.minFontSize = $attrs.min || Number.NEGATIVE_INFINITY;
        $scope.maxFontSize = $attrs.max || Number.POSITIVE_INFINITY;


        var newValueIsHours = parseInt(newValue) >= 3600;
        var oldValueIsHours = parseInt(oldValue) >= 3600;


        if (newValueIsHours !== oldValueIsHours) { 
          $scope.compressor = 0.65;
          resizer();
        }

        angular.element( $window ).bind( 'resize', function() {
          resizer();
        });
      });

      resizer();

    }
  };
}]);
