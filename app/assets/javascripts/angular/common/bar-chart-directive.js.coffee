angular.module("app").
  directive("tiBarChart", () ->
    {
      restrict: "E",
      replace: true,
      template: '<div><svg id="{{chartId}}"></svg></div>'
      scope:
        chartData: "="
        chartId: "@"
        chartTitle: "@"
        elapsedFilter: "="
      link: ($scope, el) =>
        chart = null
        currentChartData = [{ key: 'Elapsed', values: [] }]

        $scope.$watch "chartData", (chartData) ->
          height = width = $(el).width()


          angular.copy(chartData, currentChartData[0].values)

          if chart
            chart.update()
          else
            nv.addGraph ->
              chart = nv.models.discreteBarChart().x((d) ->
                d.key
              ).y((d) ->
                d.value / 3600
              ).staggerLabels(false).tooltips(true).showValues(false).transitionDuration(1000)
                .height(300)
                .tooltipContent (name, key, value) ->
                  return "#{key} - #{ $scope.elapsedFilter( value * 3600 ) }"

              d3.select("##{$scope.chartId}").attr('height', 300).datum(currentChartData).call chart
              nv.utils.windowResize chart.update
              chart

    }
  )

