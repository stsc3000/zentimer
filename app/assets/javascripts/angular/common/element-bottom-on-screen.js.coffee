angular.module("app").
  service("ElementBottomOnScreen", ($window) ->
    {
      check: (el, preLoad=0) ->
        pos = $(el).offset().top
        elHeight = $(el).height()
        scrollY = $window.scrollY
        windowHeight = $($window).height()
        preLoad = 300
        pos - scrollY - preLoad - windowHeight - elHeight <= 0
    }
  )
