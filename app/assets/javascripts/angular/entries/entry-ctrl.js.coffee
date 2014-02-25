angular.module("entries").
  controller("EntryCtrl", ($scope, ZenTimer, Projects, Tags) ->

    Tags.tags().then (tags) ->
      $scope.tagSuggestions = tags

    Projects.projects().then (projects) ->
      $scope.projectSuggestions = projects

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

    $scope.persist = ->
      @entry.persist()

  )
