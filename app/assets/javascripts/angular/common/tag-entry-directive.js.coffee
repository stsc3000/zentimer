angular.module("app").
  directive("tiTagEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<div class="tags-entry">
                  <ul data-role="tags" class="tags-entry-tag-list">
                    <ti-tag ng-repeat="tag in targetValue" tag="tag"></ti-tag>
                    <li><input data-role="tag-entry" class="tags-entry-tag-input" ng-model="currentTag" placeholder="{{ placeholder }}"></input></li>
                  </ul>
                  <div class="tags-entry-suggestion-list">
                    <ul>
                      <li class="tags-entry-suggestion-item" ng-class="{active:$index==suggestionIndex}" ng-mousedown="selectTag(suggestion)" ng-repeat="suggestion in suggestions | orderBy:\'toString()\'">
                        <a>{{ suggestion }}</a>
                      </li>
                    </ul>
                  </div>
                </div>'
      scope:
        targetValue: "=on"
        update: "&"
        suggestionDomain: "="
        placeholder: "@"

      controller: ($scope) ->
        $scope.suggestionIndex = -1
        $scope.suggestions = []
        $scope.suggestionsEnabled = ->
          $scope.suggestionDomain && $scope.suggestionDomain.length > 0

        $scope.removeTag = (tag) ->
          $scope.targetValue.splice _.indexOf($scope.targetValue, _.find($scope.targetValue, (item) ->
            item is tag
          )), 1
          $scope.update()

        $scope.addTag = (tag) ->
          unless _.include($scope.targetValue, tag) || !tag
            $scope.targetValue.push(tag)

        $scope.selectTag = (suggestion) ->
          $scope.addTag(suggestion)
          $scope.suggestions.clear()
          $scope.currentTag = ""
          $scope.update()

        $scope.clearSuggestions = ->
          if $scope.suggestionsEnabled()
            $scope.suggestionIndex = -1
            $scope.suggestions.clear()

        $scope.showSuggestions = ->
          if $scope.suggestionsEnabled()
            tag = $scope.currentTag || ""
            if tag
              allSuggestions = _.filter( $scope.suggestionDomain, ((potentialMatch) -> potentialMatch.toLowerCase().indexOf(tag.toLowerCase()) == 0 ))
              $scope.suggestions = _.difference(allSuggestions, $scope.targetValue)
            else
              $scope.clearSuggestions()
            if $scope.suggestions.length == 0
              $scope.suggestionIndex = -1


        $scope

      link: ($scope, el) ->


        input = el.find("[data-role=tag-entry]")
        suggestions = el.find(".tags-entry-suggestion-list")

        input.blur ->
          $scope.clearSuggestions()
          $scope.$apply()

        el.click (e) ->
          input.focus()
          e.stopPropagation()

        input.focus ->
          $scope.showSuggestions()
          suggestions.css("left", input.position().left - 10)

        el.keydown (event) ->
          #press backspace
          if event.keyCode == 8 && input.val() == ""
            $scope.targetValue.pop()
            $scope.clearSuggestions()
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
              tag = $scope.suggestions.sort()[$scope.suggestionIndex]
            else
              tag = $scope.currentTag.replace(",","")

            $scope.addTag(tag)
            $scope.currentTag = ""
            $scope.clearSuggestions()
            $scope.update()

          #update suggestions
          else
            $scope.showSuggestions()
            suggestions.css("left", input.position().left - 10)

          $scope.$apply()

    }
  )

