var module = angular.module('fitText', []);

module.directive('fittext', [ '$window', '$document', function( $window, $document ) {
  return {
    restrict: 'A',
    scope: {
      watch: '=',
      compressor: '@'
    },
    link: function( $scope, $element, $attrs ) {
      $scope.$watch('watch', function() {
        $scope.compressor = $attrs.compressor || 1;
        $scope.minFontSize = $attrs.min || Number.NEGATIVE_INFINITY;
        $scope.maxFontSize = $attrs.max || Number.POSITIVE_INFINITY;

        var resizer = function() {
          $scope.fontSize = Math.max(
            Math.min(
              $element[0].offsetWidth / ( $scope.compressor * 10 ),
              parseFloat( $scope.maxFontSize )
          ),
          parseFloat( $scope.minFontSize )
          ) + 'px';
          $element.css('font-size', $scope.fontSize);
        };

        resizer();

        angular.element( $window ).bind( 'resize', function() {
          resizer();
        });
      });

    }
  };
}]);
