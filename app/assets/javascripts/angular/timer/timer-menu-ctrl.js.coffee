angular.module("timer")
  .controller("TimerMenuCtrl", ($scope, Timer) ->
    $scope.timer = Timer

    $scope.addEntry = ->
      @timer.addManualEntry()

    $scope.clear = ->
      @timer.clear()

    $scope.totalElapsed = ->
      @timer.totalElapsed()


  )
