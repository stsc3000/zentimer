angular.module("app").
  directive("tiTagEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<div class="tags-entry">
                  <ul data-role="tags" class="tags">
                    <ti-tag ng-repeat="tag in targetValue" tag="tag"></ti-tag>
                  </ul>
                  <input data-role="tag-entry" class="tag-entry"></input>
                  <div style="clear:both"></div>
                </div>'
      scope:
        targetValue: "=on"
        update: "&"

      controller: ($scope) ->
        $scope.removeTag = (tag) ->
          $scope.targetValue.splice _.indexOf($scope.targetValue, _.find($scope.targetValue, (item) ->
            item is tag
          )), 1
          $scope.update()
        $scope

      link: ($scope, el) ->
        input = el.find("[data-role=tag-entry]")

        el.click ->
          input.focus()

        el.keyup (event) ->
          #press backspace
          if event.keyCode == 8 && input.val() == ""
            $scope.targetValue.pop()
            $scope.update()
          #press , or enter
          if event.keyCode == 188 || event.keyCode == 13
            tag = input.val().replace(",","")
            unless _.include($scope.targetValue, tag) || !tag
              $scope.targetValue.push(tag)
            input.val("")
            $scope.update()
          $scope.$apply()

    }
  )

