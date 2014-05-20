angular.module("app").
  directive("tiFlash", (Audio) ->
    {
      restrict: "A",
      link: ($scope, el) ->
        $scope.$on 'flash', ->
          $(el).removeClass("flash")
          $(el).addClass("flash")
          setTimeout( ( -> $(el).removeClass("flash")), 1000)
    }
  )

