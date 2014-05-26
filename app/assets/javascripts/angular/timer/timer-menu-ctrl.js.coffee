angular.module("timer")
  .controller("TimerMenuCtrl", ($scope, Timer) ->
    $scope.timer = Timer

    $scope.addEntry = ->
      @timer.addIntentionalEntry()

    $scope.clear = ->
      question = "Are you sure you want to clear all entries?"
      @timer.clear() if window.confirm(question)

    $scope.totalElapsed = ->
      @timer.totalElapsed()

  )
