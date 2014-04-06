angular.module("app").
  directive("tiAudio", (Audio) ->
    {
      restrict: "E",
      replace: true,
      template: ' <audio preload="auto">
      </audio>'
      scope:
        filename: "@"
      link: ($scope, el) ->
        $(el).append("<source src='assets/#{$scope.filename}.mp3'></source>")
        $(el).append("<source src='assets/#{$scope.filename}.ogg'></source>")
        Audio.register($scope.filename, el[0])
    }
  )

