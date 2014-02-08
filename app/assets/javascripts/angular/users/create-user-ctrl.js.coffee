angular.module("users").
  controller("CreateUserCtrl", ($scope, $http, user) ->
    $scope.user = user
    $scope.createUser = ->
      $http.post("/users").success (response) ->
        window.location = response.url
  )
