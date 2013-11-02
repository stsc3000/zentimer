angular.module("models").
  factory("Entry", (EntryResource, $q) ->
    defaultAttributes = 
      elapsed: 0
      description: ""

    Entry = (attributes) ->
      angular.extend(@, defaultAttributes)
      angular.extend(@, attributes)

    Entry.entries = []
    Entry.fetch = ->
      deferred = $q.defer()
      if !_.isEmpty(@entries)
        deferred.resolve(@entries)
        return deferred.promise
      else
        anotherPromise = EntryResource.fetch().then (entries) ->
          Entry.entries = _.map entries, (entry) -> new Entry(entry)
        return anotherPromise

    Entry.prototype.increment = (seconds = 1) ->
      @elapsed += seconds

    Entry
  )
