angular.module("app").
  directive("tiTag", ->
    {
      restrict: "E"
      replace: true
      template: '<li>{{ tag }} <a ng-click="removeTag()"> <i class="fa fa-times-circle fa-fw"class="fa fa-times-circle fa-fw"></a></i> </li>'
      scope:
        tag: "="
      require: "^ti-tag-entry"
      link: ($scope, el, attrs, tagEntryCtrl) ->
        $scope.removeTag = ->
          tagEntryCtrl.removeTag($scope.tag)
    }
  )
