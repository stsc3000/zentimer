angular.module("timer")
  .controller("TimerEntryListCtrl", ($scope, Timer, Settings) ->
    $scope.timer = Timer

    Settings.tags().then (tags) ->
      $scope.tags = tags

    Settings.projects().then (projects) ->
      $scope.projects = projects

    $scope.continue = (entry) ->
      @timer.continue(entry)

    $scope.pause = (entry) ->
      @timer.pause(entry)

    $scope.remove = (entry) ->
      @timer.remove(entry)

  )
