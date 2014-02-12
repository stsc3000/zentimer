angular.module("app").
  directive("tiTagEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<div class="tags-entry">
                  <ul data-role="tags" class="tags">
                    <li ng-repeat="tag in targetValue">{{ tag }} <i class="fa fa-times-circle fa-fw"class="fa fa-times-circle fa-fw"></i> </li>
                  </ul>
                  <input data-role="tag-entry" class="tag-entry"></input>
                  <div style="clear:both"></div>
                </div>'
      scope:
        targetValue: "=on"

      link: ($scope, el) ->
        input = el.find("[data-role=tag-entry]")

        el.keyup (event) ->
          #press backspace
          if event.keyCode == 8 && input.val() == ""
            $scope.targetValue.pop()
          #press , or enter
          if event.keyCode == 188 || event.keyCode == 13
            tag = input.val().replace(",","")
            unless _.include($scope.targetValue, tag) || !tag
              $scope.targetValue.push(tag)
            input.val("")
          $scope.$apply()

    }
  )

