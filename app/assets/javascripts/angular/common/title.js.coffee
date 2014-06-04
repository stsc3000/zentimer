angular.module("app").
  service("Title", (elapsedFilter) ->
    {
      elapsedFilter: elapsedFilter,
      set: (entry) ->
        document.title = "#{@elapsedFilter(entry.elapsed)} - ZenTimer"
      clear: ->
        document.title = "ZenTimer"
    }
  )
