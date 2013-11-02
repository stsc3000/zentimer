angular.module("models").
  factory("Entry", (EntryResource, $q) ->
    defaultAttributes = 
      elapsed: 0
      description: ""
      running: false

    Entry = (attributes) ->
      angular.extend(@, defaultAttributes)
      angular.extend(@, attributes)

    Entry.entries = []

    Entry.save = (entry) ->
      @entries.push(entry) unless entry.id

    Entry.newEntry = ->
      new Entry

    Entry.fetch = ->
      deferred = $q.defer()
      if !_.isEmpty(@entries)
        deferred.resolve(@entries)
        return deferred.promise
      else
        anotherPromise = EntryResource.fetch().then (entries) ->
          angular.copy(
            _.map(entries, (entry) -> new Entry(entry) ),
            Entry.entries 
          )
        return anotherPromise

    Entry.prototype.increment = (seconds = 1) ->
      @elapsed += seconds

    Entry.prototype.start = ->
      @running = true

    Entry.prototype.pause = ->
      @running = false

    Entry
  )
