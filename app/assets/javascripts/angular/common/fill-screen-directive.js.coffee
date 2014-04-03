angular.module("app").
  directive("tiFillScreen", ($window, $timeout, ElementBottomOnScreen) ->
    {
      restrict: 'A'
      link: ($scope, el, attrs) ->

        needToLoadNextPage = ->
          ElementBottomOnScreen.check(el, 300)

        $scope.update = ->
          $scope.$eval(attrs.tiFillScreen)

        onScroll = =>
          if needToLoadNextPage()
            $scope.$apply ->
              $scope.update()

        if $scope.$last == true
          $timeout ->
            onScroll()
    }
  )
