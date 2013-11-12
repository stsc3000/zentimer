angular.module("entries").
  controller("EntryCtrl", ($scope, ZenTimer) ->
    $scope.editing = false

    $scope.hasRunOnce = (entry) ->
      entry.elapsed > 0

    $scope.delete = ->
      ZenTimer.delete(@entry)

    $scope.continue =  ->
      ZenTimer.continue(@entry)

    $scope.pause = ->
      ZenTimer.pause()

    $scope.toggleEdit = ->
      @editing = !@editing

  )
