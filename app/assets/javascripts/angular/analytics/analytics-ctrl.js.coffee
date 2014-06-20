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

    $scope.csvUrl = ->
      queryData = $scope.query.entryList.queryData
      params = [
        "token=#{queryData.token}",
        "query[date_filter][from]=#{queryData.query.date_filter.from}",
        "query[date_filter][to]=#{queryData.query.date_filter.to}",
        "query[projects]=#{queryData.query.projects || []}",
        "query[tags][include]=#{queryData.query.tags.include || []}",
        "query[tags][exclude]=#{queryData.query.tags.exclude || []}",
      ]
      "entries/filter.csv/?#{params.join("&")}"


    $scope.$watch "query.entries", ( -> $scope.query.updateEntriesGroupedByProject() ), true
)
