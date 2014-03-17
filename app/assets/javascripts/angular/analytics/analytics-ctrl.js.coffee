angular.module("analytics").
  controller("analyticsCtrl", ($scope, $http, Query, user) ->

    $scope.query = Query

    $scope.toggleFilterSubmenu = (type) ->
      if $scope.filterSubmenu == type
        $scope.filterSubmenu = undefined
      else
        $scope.filterSubmenu = type

    $scope.query.fetch()

    $scope.$watch "query.entries", ( -> $scope.query.updateEntriesGroupedByProject() ), true
)
