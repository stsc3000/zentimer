angular.module("entries-list").
  controller("EntriesListCtrl", (Entry, TimerService,  $scope) ->
    $scope.entries = Entry.entries

    $scope.continueEntry = (entry) ->
      console.log("continue")
      TimerService.continue(entry)

    $scope.delete = (entry) ->
      console.log("delete")
      TimerService.delete(entry)
  )
