angular.module("app").
  directive("tiQuickEntry", ->
    {
      restrict: "A"
      link: ($scope, el) ->
        $(el).find('input, textarea').focus (e) ->
          $scope.$apply ->
            $scope.showAdditionalInfo = true

        $(".page").click (e) ->
          $scope.$apply ->
            $scope.showAdditionalInfo = false

    }
  )
