angular.module("entries").
  controller("EntriesListCtrl", ($scope, ZenTimer) ->
    $scope.hasRunOnce = (entry) ->
      entry.hasRunOnce()

    $scope.addEntry = ->
      ZenTimer.addEntry()

    $scope.totalElapsed = ->
      ZenTimer.totalElapsed()

    $scope.clear = ->
      question = "Are you sure you want to clear all entries?"
      ZenTimer.clear() if window.confirm(question)

    $scope.entries = ZenTimer.entries
  )
