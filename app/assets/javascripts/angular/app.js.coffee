#= require_self
#= require_tree .


angular.module("app", ["zen-timer", "ngFitText", "users", "entries", "settings", "ngAnimate", "ngRoute"])

angular.element(document).ready ->
  if $("meta[name=user-token]").length > 0
    user = { token: $("meta[name=user-token]").attr("content") }
  angular.module("app").value("user",  user)
  angular.bootstrap document, ['app']

angular.module("app")
  .config ($routeProvider) ->
    $routeProvider.when('/', { templateUrl: 'tpls/timer' })
    .when('/settings', { templateUrl: 'tpls/settings' })
    .when('/analytics', { templateUrl: 'tpls/analytics' })

angular.module("app")
  .run ($rootScope, $timeout) ->
    $rootScope.$on "$viewContentLoaded", ->
      #HACK! but I can't find a relevant callback for this
      $timeout ( ->
        $rootScope.enableAnimations = true unless $rootScope.enableAnimations
      ), 200
