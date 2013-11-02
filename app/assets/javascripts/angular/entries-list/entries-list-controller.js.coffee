angular.module("entries-list").
  controller("EntriesListCtrl", (Entry, TimerService,  $scope) ->
    $scope.entries = Entry.entries

    $scope.continueEntry = (entry) ->
      TimerService.continue(entry)
  )
