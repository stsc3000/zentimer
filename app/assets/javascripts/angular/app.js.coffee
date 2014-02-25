#= require_self
#= require_tree .


angular.module("app", ["zen-timer", "fitText", "users", "entries", "settings"])

angular.element(document).ready ->
  if $("meta[name=user-token]").length > 0
    user = { token: $("meta[name=user-token]").attr("content") }
  angular.module("app").value("user",  user)
  angular.bootstrap document, ['app']
