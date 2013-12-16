angular.module("app").
  directive("tiElapsedEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<span><form name="entry" class="entry-elapsed-form" ng-submit="save()">  <i class="fa fa-clock-o fa-fw"></i> <input class="elapsed-entry" ng-disabled="disabled" type="text" ng-model="time" ng-enter="save()"></input></form></span>'
      scope:
        elapsed: "=elapsed"
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
          $scope.elapsed = elapsed
          #$scope.entry.updateElapsed(elapsed)

          #$scope.persist(elapsed)

      link: ($scope) ->
        pad = (n, width) ->
          z = "0"
          n = n + ""
          (if n.length >= width then n else new Array(width - n.length + 1).join(z) + n)

        $scope.$watch "elapsed", (elapsed) ->
          console.log("adjusting elapsed")
          if elapsed
            $scope.hours = pad Math.floor( elapsed / Math.pow( 60, 2 )), 2
            $scope.minutes = pad Math.floor( elapsed / 60 ) % 60, 2
            $scope.seconds = pad (elapsed % 60), 2
          else
            $scope.hours = $scope.minutes = $scope.seconds = "00"

          time = ""
          if $scope.hours > 0
            time = "#{$scope.hours}:"
          $scope.time = time + "#{$scope.minutes}:#{$scope.seconds}"

    }
  )

