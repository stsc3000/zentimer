angular.module("app").
  directive("tiCopy", ->
    {
      restrict: "A"
      scope:
        copySource: "="
      link: ($scope, el, attrs) ->
        client = null
        $scope.$watch "copySource", ((copySource) ->
          client.destroy() if client
          client = new ZeroClipboard el,
            moviePath: "/ZeroClipboard.swf"
          client.setText $scope.copySource.join(", ")
          client.on "load", (client, args) ->
            client.on "complete", (client, args) ->
              console.log("copied")
            client.on 'mouseover', (client, args) ->
              $(el).closest(".entry-row-hidden").addClass("hover")
            client.on 'mouseout', (client, args) ->
              $(el).closest(".entry-row-hidden").removeClass("hover")
          ), true
      }
  )
