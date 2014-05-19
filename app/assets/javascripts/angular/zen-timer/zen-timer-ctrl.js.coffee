angular.module("zen-timer").
  controller("ZenTimerCtrl", ($scope, ZenTimer, Settings, $rootScope) ->

    ZenTimer.init()
    $scope.timer = ZenTimer

    Settings.tags().then (tags) ->
      $scope.suggestions = tags

    Settings.projects().then (projects) ->
      $scope.projects = projects

    $scope.done = () ->
      @timer.done()

    $scope.toggle = ->
      @timer.toggle()

    $scope.$on 'keypress:112', (whateverThisIs, event) ->
      $scope.toggle()
    $scope.$on 'keypress:80', (whateverThisIs, event) ->
      $scope.toggle()

    $scope.$on 'keypress:110', (whateverThisIs, event) ->
      $scope.done()
      $scope.toggle()
    $scope.$on 'keypress:78', (whateverThisIs, event) ->
      $scope.done()
      $scope.toggle()

    $scope.showDoneButton = ->
      @timer.savable()

    $scope.delete = ->
      @timer.deleteCurrent()

    $scope.persistCurrentEntry = ->
      @timer.persistCurrentEntry()

  )
