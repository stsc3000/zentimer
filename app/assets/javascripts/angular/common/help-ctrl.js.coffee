angular.module("app").
  controller("helpCtrl", ($scope) ->
    $scope.$on 'keypress:104', (whateverThisIs, event) ->
      $scope.displayAppInfo = !!!$scope.displayAppInfo
  )
