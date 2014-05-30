angular.module("timer")
  .controller("TimerCtrl", ($scope, Timer, Settings) ->

    $scope.timer = Timer

    Settings.tags().then (tags) ->
      $scope.tags = tags

    Settings.projects().then (projects) ->
      $scope.projects = projects

    $scope.toggle = ->
      @timer.toggle()

    $scope.stop = ->
      @timer.stop()

    $scope.showEntryActions = ->
      @timer.entryIsStoppable()

    $scope.removeCurrent = ->
      @timer.removeCurrent()

  )
