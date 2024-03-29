angular.module("app").
  directive("tiScrollSpy", ($window, $timeout, ElementBottomOnScreen) ->
    {
      restrict: 'E'
      scope:
        update: '&'
      link: ($scope, el, attrs) ->

        needToLoadNextPage = ->
          ElementBottomOnScreen.check(el, 300)

        onScroll = =>
          if needToLoadNextPage()
            $scope.$apply ->
              $scope.update()

        $($window).scroll onScroll
    }
  )
