angular.module("app").directive "tiRevealModal", ->
  (scope, elem, attrs) ->
    scope.$watch attrs.tiRevealModal, (val) ->
      if val
        $(elem).foundation('reveal', 'open')
      else
        $(elem).foundation('reveal', 'close')
