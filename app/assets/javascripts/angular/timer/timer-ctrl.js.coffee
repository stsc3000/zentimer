angular.module("timer")
  .controller("TimerCtrl", ($scope, Timer, Settings) ->

    $scope.timer = Timer

    Settings.tags().then (tags) ->
      $scope.tags = tags

    Settings.projects().then (projects) ->
      $scope.projects = projects

    $scope.toggle = ->
      @timer.toggle()

    $scope.stop = ->
      @timer.stop()

    $scope.showEntryActions = ->
      @timer.entryIsStoppable()

    $scope.removeCurrent = ->
      @timer.removeCurrent()

    $scope.$on 'keypress:112', (whateverThisIs, event) ->
      $scope.toggle()
    $scope.$on 'keypress:80', (whateverThisIs, event) ->
      $scope.toggle()

    $scope.$on 'keypress:110', (whateverThisIs, event) ->
      $scope.stop()
      $scope.toggle()
    $scope.$on 'keypress:78', (whateverThisIs, event) ->
      $scope.stop()
      $scope.toggle()

  )
