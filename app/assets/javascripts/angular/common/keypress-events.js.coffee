angular.module("app").directive "keypressEvents", ($document, $rootScope) ->
  restrict: "A"
  link: ->
    $document.bind "keypress", (e) ->
      unless $(e.target).is("input") || $(e.target).is("textarea")
        console.log("pressed")
        $rootScope.$broadcast "keypress", e
        $rootScope.$broadcast "keypress:" + e.which, e
