angular.module("app").
  directive("tiSpinner", (Loading) ->
    {
      restrict: "E"
      replace: true
      template: '<div class="full-screen-overlay"> <div class="spinner"> <div class="dot1"></div> <div class="dot2"></div> </div> <h2> loading </h2> </div>'
      link: ($scope, el, attrs) ->
        onLoad = -> $(el).show()
        onLoaded = -> $(el).fadeOut(500)
        Loading.subscribe
          onLoad: onLoad
          onLoaded: onLoaded

    }
  )
