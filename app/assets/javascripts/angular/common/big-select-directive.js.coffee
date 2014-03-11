angular.module("app").
  directive("tiBigSelect", ->
    {
      restrict: "A"
      transclude: 'element'
      replace: true
      template: "<div> <div ng-click='showSelects()'  ng-transclude class='big-select-current-selection'></div> 
          <div class='row'>
            <ul class='big-select-list large-8 columns text-center' >
              <li class='big-select-item selected' ng-click='selectOption(selectedOption)'> {{ selectedOption.name }} <span class='fa fa-fw fa-chevron-up'></span> </li>
              <li class='big-select-item' ng-repeat='option in unselectedOptions' ng-click='selectOption(option)'> {{ option.name }} </li>
            </ul> 
          <div class='clearfix'></div>
          </div>
        </div>"
      scope:
        selectModel: "="
        selectRange: "="
      compile: ->
        ($scope, el, attrs) ->
          listEl = $(el).find('.big-select-list')
          $scope.unselectedOptions = []

          $scope.selectOption = (option) ->
            $scope.selectModel = option.value
            $scope.hideSelect()
            return undefined

          $scope.showSelects = ->
            shadowEl = $("<div id='shadow' style='display: none'></div>")
            shadowEl.click $scope.hideSelect
            $("body").append shadowEl

            $scope.unselectedOptions = _.reject $scope.selectRange, (option) -> option.value == $scope.selectModel
            $scope.selectedOption = _.find $scope.selectRange, (option) -> option.value == $scope.selectModel
            selectedEl = $(el).find('.filter-value')
            listEl.css("left", selectedEl.position().left + "px")
            listEl.css("top", selectedEl.position().top + "px")
            listEl.css("width", selectedEl.outerWidth() + "px")
            listEl.show()
            shadowEl.show()
            return undefined

          $scope.hideSelect = ->
            $("#shadow").remove()
            listEl.hide()



    }
  )
