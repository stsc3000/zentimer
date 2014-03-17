angular.module("app").
  directive("tiDonutChart", ->
    {
      restrict: "E",
      replace: true,
      template: '<div><svg id="{{chartId}}"></svg></div>'
      scope:
        chartData: "="
        chartId: "@"
        chartTitle: "@"
      link: ($scope, el) ->
        chart = null
        currentChartData = []

        $scope.$watch "chartData", (chartData) ->
          width = 500
          height = 500

          angular.copy(chartData, currentChartData)

          if chart
            chart.update()
          else
            nv.addGraph ->
              chart = nv.models.pieChart()
                .x( (d) -> d.key )
                .color(d3.scale.category10().range())
                .width(width)
                .height(height)
                .donut(true)

              d3.select("##{$scope.chartId}")
                .datum(currentChartData)
                .transition().duration(5000)
                .attr('width', width)
                .attr('height', height)
                .call(chart)
              chart

    }
  )

