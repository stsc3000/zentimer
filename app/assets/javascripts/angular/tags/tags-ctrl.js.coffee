angular.module("tags").
  controller("tagsCtrl", ($scope, Tags) ->
    Tags.tags().then (tags) ->
      $scope.tags = tags

    $scope.save = ->
      Tags.save($scope.tags).then (tags) ->
        $scope.tags = tags
  )
