angular.module("app").
  directive("tiScrollSpy", ($window) ->
    {
      restrict: 'E'
      replace: true
      template: '<div>&nbsp;</div>'
      scope:
        update: '&'
      link: ($scope, el, attrs) ->

        onScroll = =>
          pos = $(el).offset().top
          elHeight = $(el).height()
          scrollY = $window.scrollY
          windowHeight = $($window).height()
          preLoad = 300
          if pos - scrollY - preLoad - windowHeight - elHeight <= 0
            $scope.$apply ->
              $scope.update()

        $($window).scroll onScroll
    }
  ) 

