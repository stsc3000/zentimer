angular.module("resources").
  factory("EntryResource", ($timeout, $q) ->
    EntryResource =
      fetch: ->

        deferred = $q.defer()

        $timeout ( =>

          console.log "FETCHING FROM BACKEND"

          entries = [
            {
              elapsed: 200
              description: "First"
              running: true
            },
            {
              elapsed: 400
              description: "Second"
              running: false
            }
          ]

          deferred.resolve entries
        ), 500

        return deferred.promise
  )
