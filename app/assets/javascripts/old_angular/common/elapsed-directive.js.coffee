angular.module("app").
  directive("tiElapsed", ->
    {
      restrict: "E",
      replace: true,
      scope:
        elapsed: "=elapsed"
      link: (scope) ->

        pad = (n, width) ->
          z = "0"
          n = n + ""
          (if n.length >= width then n else new Array(width - n.length + 1).join(z) + n)

        scope.$watch "elapsed", (elapsed) ->
          if elapsed
            scope.hours = pad Math.floor( elapsed / Math.pow( 60, 2 )), 2
            scope.minutes = pad Math.floor( elapsed / 60 ) % 60, 2
            scope.seconds = pad (elapsed % 60), 2
          else
            scope.hours = scope.minutes = scope.seconds = "00"

    }
  )

