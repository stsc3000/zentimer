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
      entry.id = (new Date).getTime()
      @entries.push(entry) unless _.include(@entries, entry) || entry.elapsed == 0
      EntryResource.save(@entries)

    Entry.delete = (entry) ->
      #remove entry properly with splice or something
      entriesWithoutEntry = _.remove(@entries, (searchEntry) -> searchEntry == entry)
      angular.copy(entriesWithoutEntry, @entries)
      EntryResource.save(@entries)

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

    Entry.prototype.save = ->
      Entry.save(@)

    Entry.prototype.increment = (seconds = 1) ->
      @elapsed += seconds
      @save() unless @deleted

    Entry.prototype.willBeDeleted = ->
      @deleted = true

    Entry.prototype.start = ->
      @running = true
      @save()

    Entry.prototype.pause = ->
      @running = false
      @save()

    Entry
  )
