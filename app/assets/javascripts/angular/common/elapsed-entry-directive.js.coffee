pad = (n, width) ->
  z = "0"
  n = n + ""
  (if n.length >= width then n else new Array(width - n.length + 1).join(z) + n)

angular.module("app").
  directive("tiElapsedEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<div class="elapsed-entry">
                  <input class="elapsed-entry-elapsed-input" ng-disabled="disabled" ng-model="time" ng-enter="save()" ng-blur="save()"></input>
                </div>'
      scope:
        elapsed: "=elapsed"
        model: "=model"
        disabled: "=disabled"
      controller: ($scope) ->

        $scope.save = ->
          time = $scope.time.split(":")
          elapsed = 0

          seconds = time.pop()
          elapsed += parseInt(seconds) if seconds

          minutes = time.pop()
          elapsed += parseInt(minutes) * 60 if minutes

          hours = time.pop()
          elapsed += parseInt(hours) * 3600 if hours
          $scope.model.elapsed = elapsed
          $scope.model.save()

      link: ($scope) ->

        $scope.$watch "elapsed", (elapsed) ->
          if elapsed
            $scope.hours = pad Math.floor( elapsed / Math.pow( 60, 2 )), 2
            $scope.minutes = pad Math.floor( elapsed / 60 ) % 60, 2
            $scope.seconds = pad Math.floor(elapsed % 60), 2
          else
            $scope.hours = $scope.minutes = $scope.seconds = "00"

          time = ""
          if $scope.hours > 0
            time = "#{$scope.hours}:"
          $scope.time = time + "#{$scope.minutes}:#{$scope.seconds}"

    }
  )

