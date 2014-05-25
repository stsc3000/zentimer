angular.module("timer")
  .controller("TimerEntryListCtrl", ($scope, Timer) ->
    $scope.timer = Timer

    $scope.continue = (entry) ->
      @timer.continue(entry)

    $scope.pause = (entry) ->
      @timer.pause(entry)

    $scope.remove = (entry) ->
      @timer.remove(entry)

  )
