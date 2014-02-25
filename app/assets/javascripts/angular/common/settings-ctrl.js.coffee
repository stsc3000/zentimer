angular.module("app").
  controller("settingsCtrl", ($scope, Tags) ->
    Tags.tags().then (tags) ->
      $scope.tags = tags

    $scope.save = ->
      Tags.save($scope.tags).then (tags) ->
        $scope.tags = tags
  )
