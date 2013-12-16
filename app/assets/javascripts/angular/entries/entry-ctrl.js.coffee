angular.module("entries").
  controller("EntryCtrl", ($scope, ZenTimer) ->
    $scope.delete = ->
      ZenTimer.delete(@entry)

    $scope.continue =  ->
      ZenTimer.continue(@entry)

    $scope.pause = ->
      ZenTimer.pause()

    $scope.toggleRunning = ->
      if @entry.running
        ZenTimer.pause()
      else
        ZenTimer.continue(@entry)

  )
