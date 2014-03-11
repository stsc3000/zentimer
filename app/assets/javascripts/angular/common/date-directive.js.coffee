angular.module("app").
  directive("tiDateModel", ->
    {
      restrict: "A"
      scope:
        tiDateModel: "="
      link: ($scope, el, attrs) ->
        el[0].valueAsDate = $scope.tiDateModel
    }

  )
