angular.module("timer").
  controller("TimerCtrl", ($scope, TimerService, Entry) ->
    $scope.timer = TimerService

    $scope.start = ->
      @timer.start()

    $scope.pause = ->
      @timer.pause()
  )
