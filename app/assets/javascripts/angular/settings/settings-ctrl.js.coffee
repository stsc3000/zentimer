angular.module("settings").
  controller("settingsCtrl", ($scope, Tags, Projects) ->
    Tags.tags().then (tags) ->
      $scope.tags = tags

    $scope.saveTags = ->
      Tags.save($scope.tags).then (tags) ->
        $scope.tags = tags

    Projects.projects().then (projects) ->
      $scope.projects = projects

    $scope.saveProjects = ->
      Projects.save($scope.projects).then (projects) ->
        $scope.projects = projects

  )
