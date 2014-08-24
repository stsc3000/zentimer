angular.module("app").
  directive("tiCopy", ->
    {
      restrict: "A"
      scope:
        copySource: "="
        copyComment: "="
      link: ($scope, el, attrs) ->
        client = null

        client = new ZeroClipboard el,
          moviePath: "/ZeroClipboard.swf"

        client.on "load", (client, args) ->
          client.on 'mouseover', (client, args) ->
            text = $scope.copySource.join(", ")
            text += "!!" + $scope.copyComment if $scope.copyComment
            client.setText text
            $(el).closest(".entries-list-item").addClass("hover")
          client.on 'mouseout', (client, args) ->
            $(el).closest(".entries-list-item").removeClass("hover")
      }
  )
