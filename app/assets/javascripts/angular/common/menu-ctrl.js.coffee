angular.module("app").
  controller("menuCtrl", ($scope, user, $route) ->
    $scope.user = user
  )
