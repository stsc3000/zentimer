angular.module("timer").
  controller("TimerCtrl", ($scope, ZenTimer) ->
    ZenTimer.init()
    $scope.timer = ZenTimer

    $scope.save = () ->
      @timer.save()

    $scope.toggle = ->
      @timer.toggle()

    $scope.showSaveButton = ->
      @timer.savable()

    $scope.jsonEntries = ->
      JSON.stringify(ZenTimer.entries)

    $scope.delete = ->
      @timer.deleteCurrent()
  )
