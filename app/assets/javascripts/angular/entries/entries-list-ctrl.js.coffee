angular.module("entries").
  controller("EntriesListCtrl", ($scope, ZenTimer) ->
    $scope.hasRunOnce = (entry) ->
      entry.hasRunOnce()

    $scope.addEntry = ->
      ZenTimer.addEntry()

    $scope.totalElapsed = ->
      ZenTimer.totalElapsed()

    $scope.entries = ZenTimer.entries
  )
