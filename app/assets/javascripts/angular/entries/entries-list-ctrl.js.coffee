angular.module("entries").
  controller("EntriesListCtrl", ($scope, ZenTimer) ->
    $scope.hasRunOnce = (entry) ->
      entry.elapsed > 0

    $scope.entries = ZenTimer.entries
  )
