angular.module("zen-timer").
  controller("ZenTimerCtrl", ($scope, ZenTimer, Settings, $rootScope, PageAnimations) ->

    PageAnimations.enable()

    ZenTimer.init()
    $scope.timer = ZenTimer

    Settings.tags().then (tags) ->
      $scope.suggestions = tags

    $scope.done = () ->
      @timer.done()

    $scope.toggle = ->
      @timer.toggle()

    $scope.showDoneButton = ->
      @timer.savable()

    $scope.delete = ->
      @timer.deleteCurrent()

    $scope.persistCurrentEntry = ->
      @timer.persistCurrentEntry()

  )
