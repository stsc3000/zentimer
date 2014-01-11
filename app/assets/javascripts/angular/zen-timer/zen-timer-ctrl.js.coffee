angular.module("zen-timer").
  controller("ZenTimerCtrl", ($scope, ZenTimer) ->
    ZenTimer.init()
    $scope.timer = ZenTimer

    $scope.save = () ->
      @timer.save()

    $scope.toggle = ->
      @timer.toggle()

    $scope.showSaveButton = ->
      @timer.savable()

    $scope.delete = ->
      @timer.deleteCurrent()
  )
