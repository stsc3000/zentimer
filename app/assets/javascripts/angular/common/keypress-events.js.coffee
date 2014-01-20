angular.module("app").directive "keypressEvents", ($document, $rootScope) ->
  restrict: "A"
  link: ->
    $document.bind "keypress", (e) ->
      console.log "Got keypress:", e.which
      console.log "event:", e
      $rootScope.$broadcast "keypress", e
      $rootScope.$broadcast "keypress:" + e.which, e
