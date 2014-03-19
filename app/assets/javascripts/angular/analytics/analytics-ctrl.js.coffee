angular.module("analytics").
  controller("analyticsCtrl", ($scope, $http, Query, user, elapsedFilter) ->

    $scope.query = Query
    $scope.elapsedFilter = elapsedFilter

    $scope.toggleFilterSubmenu = (type) ->
      console.log $scope.query.selectedDateFilter
      if $scope.filterSubmenu == type && $scope.query.selectedDateFilter.id != 'fromTo'
        $scope.filterSubmenu = undefined
      else
        $scope.filterSubmenu = type

    $scope.query.fetch()

    $scope.$watch "query.entries", ( -> $scope.query.updateEntriesGroupedByProject() ), true
)
