angular.module("timer")
  .controller("TimerCtrl", ($scope, Timer) ->
    $scope.timer = Timer

    $scope.toggle = ->
      @timer.toggle()

    $scope.stop = ->
      @timer.stop()

    $scope.showEntryActions = ->
      @timer.entryIsStoppable()

    $scope.removeCurrent = ->
      @timer.removeCurrent()

  )
