angular.module("settings").
  controller("settingsCtrl", ($scope, Settings, PageAnimations) ->
    PageAnimations.enable()

    Settings.tags().then (tags) ->
      $scope.tags = tags

    $scope.saveTags = ->
      Settings.saveTags($scope.tags).then (tags) ->
        $scope.tags = tags

    Settings.projects().then (projects) ->
      $scope.projects = projects

    $scope.saveProjects = ->
      Settings.saveProjects($scope.projects).then (projects) ->
        $scope.projects = projects

  )
