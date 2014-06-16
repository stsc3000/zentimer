#= require_self
#= require_tree .

angular.module("app", ["zen-timer", "ngFitText", "users", "entries", "settings", "analytics", "timer", "ngAnimate", "ngRoute", "ngQuickDate", 'monospaced.elastic'])

angular.element(document).ready ->
  if $("meta[name=user-token]").length > 0
    user = { token: $("meta[name=user-token]").attr("content") }
  angular.module("app").value("user",  user)
  angular.bootstrap document, ['app']

angular.module("app")
  .config ($routeProvider) ->
    $routeProvider.when('/', { templateUrl: 'tpls/timer', resolve: { loadEntries: (Loading, Timer) -> Loading.wrap(Timer.loadEntries()) } })
    .when('/settings', { templateUrl: 'tpls/settings' })
    .when('/analytics', { templateUrl: 'tpls/analytics', resolve: { loadEntries: (Loading, Query) -> Loading.wrap(Query.fetch()) } })
  .config (ngQuickDateDefaultsProvider) ->
    # Configure with icons from font-awesome
    ngQuickDateDefaultsProvider.set
      closeButtonHtml: "<i class='fa fa-times'></i>"
      nextLinkHtml: "<i class='fa fa-chevron-right'></i>"
      prevLinkHtml: "<i class='fa fa-chevron-left'></i>"
  angular.module("app")
  .run ($rootScope, $timeout) ->
    $rootScope.menuVisible = false

    $rootScope.toggleMenu  = ->
      $rootScope.menuVisible = !$rootScope.menuVisible
