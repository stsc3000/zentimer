angular.module("app").
  directive("tiTag", ->
    {
      restrict: "E"
      replace: true
      template: '<li class="tags-entry-tag-item">{{ tag }} <a class="tag-entry-tag-item-remove" ng-click="removeTag()"> <i class="tag-entry-tag-item-remove-icon"></a></i> </li>'
      scope:
        tag: "="
      require: "^ti-tag-entry"
      link: ($scope, el, attrs, tagEntryCtrl) ->
        $scope.removeTag = ->
          tagEntryCtrl.removeTag($scope.tag)
    }
  )
