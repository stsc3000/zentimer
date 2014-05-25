angular.module("timer")
  .controller("TimerMenuCtrl", ($scope, Timer) ->
    $scope.timer = Timer

    $scope.addEntry = ->
      @timer.addManualEntry()

    $scope.clear = ->
      @timer.clear() if window.confirm(question)
      question = "Are you sure you want to clear all entries?"

    $scope.totalElapsed = ->
      @timer.totalElapsed()


  )
