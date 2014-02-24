angular.module("app").
  directive("tiTagEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<div class="tags-entry">
                  <ul data-role="tags" class="tags">
                    <ti-tag ng-repeat="tag in targetValue" tag="tag"></ti-tag>
                  </ul>
                  <input data-role="tag-entry" class="tag-entry" ng-model="currentTag" ></input>
                  <div style="clear:both"></div>
                  <div class="suggestions">
                    <ul >
                      <li class="suggestion" ng-class="{active:$index==suggestionIndex}" ng-mousedown="selectTag(suggestion)" ng-repeat="suggestion in suggestions">
                        <a>{{ suggestion }}</a>
                      </li>
                      <div style="clear:both"></div>
                    </ul>
                  </div>
                </div>'
      scope:
        targetValue: "=on"
        update: "&"

      controller: ($scope) ->
        $scope.suggestionIndex = -1
        $scope.suggestions = []
        $scope.removeTag = (tag) ->
          $scope.targetValue.splice _.indexOf($scope.targetValue, _.find($scope.targetValue, (item) ->
            item is tag
          )), 1
          $scope.update()
        $scope.tagDomain=[ "Konzeption", "Integration/Deployment","Testing","Qualitätssicherung","Nachbesserungen","Bugfixing","Refactoring","Projektkoordination","Support","Kunden-Meeting","Team-Meeting","Pair Programming","Cross-Browser","Infrastruktur","SEO","Conversion-Optimierung","Design"]

        $scope.addTag = (tag) ->
          unless _.include($scope.targetValue, tag) || !tag
            $scope.targetValue.push(tag)

        $scope.selectTag = (suggestion) ->
          $scope.addTag(suggestion)
          $scope.suggestions.clear()
          $scope.currentTag = ""

        $scope.clearSuggestions = ->
          $scope.suggestionIndex = -1
          $scope.suggestions.clear()
          $scope.$apply()

        $scope

      link: ($scope, el) ->
        input = el.find("[data-role=tag-entry]")
        suggestions = el.find(".suggestions")

        input.blur ->
          $scope.clearSuggestions()

        el.click ->
          input.focus()

        el.keydown (event) ->
          #press backspace
          if event.keyCode == 8 && input.val() == ""
            $scope.targetValue.pop()
            $scope.suggestions.clear()
            $scope.update()


        el.keyup (event) ->

          if event.keyCode == 40
            if $scope.suggestionIndex <= $scope.suggestions.length - 2
              $scope.suggestionIndex += 1 
          if event.keyCode == 38
            if $scope.suggestionIndex > -1
              $scope.suggestionIndex -= 1 

          #press , or enter
          if event.keyCode == 188 || event.keyCode == 13

            if ($scope.suggestionIndex > -1)
              tag = $scope.suggestions[$scope.suggestionIndex]
            else
              tag = $scope.currentTag.replace(",","")

            $scope.addTag(tag)
            $scope.currentTag = ""
            $scope.clearSuggestions()
            $scope.update()

          #update suggestions
          else
            tag = $scope.currentTag
            suggestions.css("left", input.position().left)
            if tag && tag.length > 0
              allSuggestions = _.filter( $scope.tagDomain, ((potentialMatch) -> potentialMatch.toLowerCase().indexOf(tag.toLowerCase()) == 0 ))
              $scope.suggestions = _.difference(allSuggestions, $scope.targetValue)
            if $scope.suggestions.length == 0
              $scope.suggestionIndex = -1

          $scope.$apply()

    }
  )

