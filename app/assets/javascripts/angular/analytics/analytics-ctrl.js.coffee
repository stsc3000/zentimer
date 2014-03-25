angular.module("analytics").
  controller("analyticsCtrl", ($scope, $http, Query, Settings, elapsedFilter) ->

    $scope.query = Query
    $scope.elapsedFilter = elapsedFilter

    Settings.tags().then (tags) ->
      $scope.tagSuggestions = tags

    Settings.projects().then (projects) ->
      $scope.projectSuggestions = projects


    $scope.toggleFilterSubmenu = (type) ->
      if $scope.filterSubmenu == type && $scope.query.selectedDateFilter.id != 'fromTo'
        $scope.filterSubmenu = undefined
      else
        $scope.filterSubmenu = type

    $scope.query.fetch()

    $scope.$watch "query.entries", ( -> $scope.query.updateEntriesGroupedByProject() ), true
)
