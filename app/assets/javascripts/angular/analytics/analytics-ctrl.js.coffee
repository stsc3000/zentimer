angular.module("analytics").
  controller("analyticsCtrl", ($scope, $http, Query, Settings, elapsedFilter) ->

    $scope.query = Query
    $scope.elapsedFilter = elapsedFilter

    Settings.tags().then (tags) ->
      $scope.tagSuggestions = tags

    Settings.projects().then (projects) ->
      $scope.projectSuggestions = projects

    $scope.toggleSecondaryMenu = (type) ->
      if $scope.secondaryMenu == type
        $scope.secondaryMenu = undefined
        $scope.tertiaryMenu = undefined
      else
        $scope.secondaryMenu = type

    $scope.selectSecondaryMenu = (filter) ->
      $scope.query.setDateFilter(filter)
      if filter.tertiary
        $scope.tertiaryMenu = filter.id
      else
        $scope.toggleSecondaryMenu('dates')

    $scope.query.fetch()

    $scope.$watch "query.entries", ( -> $scope.query.updateEntriesGroupedByProject() ), true
)
