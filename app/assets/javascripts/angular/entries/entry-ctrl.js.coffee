angular.module("entries").
  controller("EntryCtrl", ($scope, ZenTimer) ->
    $scope.editing = false

    $scope.delete = ->
      ZenTimer.delete(@entry)

    $scope.continue =  ->
      ZenTimer.continue(@entry)

    $scope.pause = ->
      ZenTimer.pause()

    $scope.toggleRunning = ->
      if @entry.running
        ZenTimer.pause()
      else
        ZenTimer.continue(@entry)

    $scope.toggleEdit = ->
      @entryDouble =
        elapsed: @entry.elapsed
        description: @entry.description
      @editing = !@editing

    $scope.update = (entryDouble) ->
      @entry.description = entryDouble.description
      @entry.elapsed = entryDouble.elapsed
      @toggleEdit()

  )
