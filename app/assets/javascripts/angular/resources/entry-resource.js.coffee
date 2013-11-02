angular.module("resources").
  factory("EntryResource", ($timeout, $q) ->
    EntryResource =
      fetch: ->

        deferred = $q.defer()

        $timeout ( =>

          console.log "FETCHING FROM BACKEND"

          entries = [
            {
              id: 1
              elapsed: 200
              description: "First"
              running: true
            },
            {
              id: 2
              elapsed: 400
              description: "Second"
              running: false
            }
          ]

          deferred.resolve entries
        ), 500

        return deferred.promise
  )
