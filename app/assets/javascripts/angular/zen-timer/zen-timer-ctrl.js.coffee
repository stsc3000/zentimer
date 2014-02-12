angular.module("zen-timer").
  controller("ZenTimerCtrl", ($scope, ZenTimer) ->
    ZenTimer.init()
    $scope.timer = ZenTimer

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

    $scope.$on 'keypress:25', (whateverThisIs, event) ->
      event.ctrlKey && $scope.toggle()

    $scope.$on 'keypress:62', (whateverThisIs, event) ->
      event.shiftKey && $scope.done() && $scope.toggle()
  )
