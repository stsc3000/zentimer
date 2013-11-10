angular.module("entries").
  controller("EntriesListCtrl", ($scope, ZenTimer) ->
    $scope.entries = ZenTimer.entries

    $scope.hasRunOnce = (entry) ->
      entry.elapsed > 0

    $scope.delete = (entry) ->
      ZenTimer.delete(entry)

    $scope.continue = (entry) ->
      ZenTimer.continue(entry)
  )
