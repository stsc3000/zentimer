angular.module("app").
  service("PageAnimations", ($rootScope) ->
    {
      enable: ->
        $rootScope.$on "$locationChangeSuccess", (scope) ->
          $rootScope.enableAnimations = true
    }
  )
