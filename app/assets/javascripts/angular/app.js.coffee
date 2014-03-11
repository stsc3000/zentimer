#= require_self
#= require_tree .


angular.module("app", ["zen-timer", "ngFitText", "users", "entries", "settings", "analytics", "ngAnimate", "ngRoute", "ngQuickDate"])

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
  .config (ngQuickDateDefaultsProvider) ->
    # Configure with icons from font-awesome
    ngQuickDateDefaultsProvider.set
      closeButtonHtml: "<i class='fa fa-times'></i>"
      nextLinkHtml: "<i class='fa fa-chevron-right'></i>"
      prevLinkHtml: "<i class='fa fa-chevron-left'></i>"
  angular.module("app")
  .run ($rootScope, $timeout) ->
    $rootScope.$on "$viewContentLoaded", ->
      #HACK! but I can't find a relevant callback for this
      $timeout ( ->
        $rootScope.enableAnimations = true unless $rootScope.enableAnimations
      ), 200


