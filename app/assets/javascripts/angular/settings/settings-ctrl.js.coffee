angular.module("settings").
  controller("settingsCtrl", ($scope, Settings) ->

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

    Settings.notificationSettings().then (notificationSettings) ->
      $scope.notificationSettings = notificationSettings

    $scope.saveAndRequestDesktopPermission = ->
      Notification.requestPermission() if $scope.notificationSettings.enableDesktopNotification
      $scope.saveNotificationSettings()

    $scope.saveNotificationSettings = ->
      Settings.saveNotificationSettings($scope.notificationSettings).then (notificationSettings) ->
        $scope.notificationSettings = notificationSettings


  )
