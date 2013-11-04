angular.module("resources").
  factory("EntryResource", ($timeout, $q) ->
    EntryResource =
      fetch: ->
        deferred = $q.defer()
        $timeout ( =>
          if (json = localStorage.getItem("entries"))
            entries = JSON.parse(json)
          else
            entries = []
          deferred.resolve entries
        ), 0
        return deferred.promise
      save: (entries) ->
        json = JSON.stringify(entries)
        localStorage.setItem("entries", json)
  )
