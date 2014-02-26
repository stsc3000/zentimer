angular.module("app").
  directive("tiProjectEntry", ->
    {
      restrict: "E",
      replace: true,
      template: '<span class="entry-edit-project">
                <i class="fa fa-square-o fa-fw"></i>
                <input type="text" ng-model="targetValue" class="project-edit" placeholder="Project" data-role="project-entry">
                <div class="suggestions">
                  <ul >
                    <li class="suggestion" ng-class="{active:$index==suggestionIndex}" ng-mousedown="selectProject(suggestion)" ng-repeat="suggestion in suggestions | orderBy:\'toString()\'">
                      <a>{{ suggestion }}</a>
                    </li>
                    <div style="clear:both"></div>
                  </ul>
                </div>
              </span>'

      scope:
        targetValue: "=on"
        update: "&"
        suggestionDomain: "="

      controller: ($scope) ->
        $scope.suggestionIndex = -1
        $scope.suggestions = []
        $scope.suggestionsEnabled = ->
          $scope.suggestionDomain && $scope.suggestionDomain.length > 0

        $scope.selectProject = (suggestion) ->
          $scope.targetValue = suggestion
          $scope.suggestions.clear()

        $scope.clearSuggestions = ->
          if $scope.suggestionsEnabled()
            $scope.suggestionIndex = -1
            $scope.suggestions.clear()

        $scope.showSuggestions = ->
          if $scope.suggestionsEnabled()
            if $scope.targetValue
              $scope.suggestions = _.filter( $scope.suggestionDomain, ((potentialMatch) -> potentialMatch.toLowerCase().indexOf($scope.targetValue.toLowerCase()) == 0 ))
            else
              $scope.clearSuggestions()
            if $scope.suggestions.length == 0
              $scope.suggestionIndex = -1

        $scope

      link: ($scope, el) ->


        input = el.find("[data-role=project-entry]")
        suggestions = el.find(".suggestions")

        input.blur ->
          $scope.clearSuggestions()
          $scope.update()
          $scope.$apply()

        el.click ->
          input.focus()

        input.focus ->
          $scope.showSuggestions()
          suggestions.css("left", input.position().left)

        input.keyup (event) ->

          if event.keyCode == 40
            if $scope.suggestionIndex <= $scope.suggestions.length - 2
              $scope.suggestionIndex += 1 
          if event.keyCode == 38
            if $scope.suggestionIndex > -1
              $scope.suggestionIndex -= 1 

          #press , or enter
          if event.keyCode == 13
            if ($scope.suggestionIndex > -1)
              $scope.targetValue = $scope.suggestions[$scope.suggestionIndex]
            $scope.clearSuggestions()
            $scope.$apply()
            $scope.update()
          #update suggestions
          else
            $scope.showSuggestions()
            suggestions.css("left", input.position().left)
            $scope.$apply()

    }
  )

