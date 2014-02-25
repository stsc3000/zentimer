angular.module("settings").
  controller("settingsCtrl", ($scope, Tags) ->
    Tags.tags().then (tags) ->
      $scope.tags = tags

    $scope.save = ->
      Tags.save($scope.tags).then (tags) ->
        $scope.tags = tags
  )
