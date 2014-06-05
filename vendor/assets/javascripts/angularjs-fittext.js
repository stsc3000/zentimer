/* ng-FitText.js v2.0.0
 * https://github.com/patrickmarabeas/ng-FitText.js
 *
 * Original jQuery project: https://github.com/davatron5000/FitText.js
 *
 * Copyright 2014, Patrick Marabeas http://marabeas.io
 * Released under the MIT license
 * http://opensource.org/licenses/mit-license.php
 *
 * Date: 25/02/2014
 */

'use strict';

angular.module( 'ngFitText', [] )
	.directive( 'fittext', [ function() {
		return {
			restrict: 'A',
			scope: {
				"fittext": "@",
				"smallFittext": "@",
				"watchtext": "@"
			},
			link: function( scope, element, attrs ) {
				scope.compressor = attrs.fittext || 1;
				scope.smallCompressor = attrs.smallFittext || 1;
				scope.minFontSize = attrs.fittextMin || Number.NEGATIVE_INFINITY;
				scope.maxFontSize = attrs.fittextMax || Number.POSITIVE_INFINITY;
				scope.elementWidth = $("#timer").width();

				( scope.resizer = function() {
					scope.fontSize = Math.max(
						Math.min(
							scope.elementWidth / ( scope.compressor * 10 ),
							parseFloat( scope.maxFontSize )
						),
						parseFloat( scope.minFontSize )
					) + 'px';

					$(element).css("font-size", scope.fontSize)
				})();

				//scope.$watch("watchtext", function() {
					//scope.elementWidth = element[0].offsetWidth;
					//scope.resizer();
				//});

				angular.element( window ).bind( 'resize', function() {
					scope.elementWidth = $("#timer").width();
					scope.resizer();
				});
			}
		}
	}]);
