angular.module("timer")
  .factory("TimerEntryList", ($q, TimerEntry) ->
    TimerEntryList = (entries, options = {})->
      @entries = entries || []
      entry.list = @ for entry in entries
      @adapter = options.adapter
      @subscribers = options.subscribers || []
      @

    instanceMethods = {

      includes: (entry) ->
        _.include @entries, entry

      store: (entry) ->
        entry.list = @
        @entries.push(entry) unless @includes(entry)

      remove: (entry) ->
        @delete(entry)
        _.remove @entries, (storedEntry) -> storedEntry == entry

      total: ->
        _.inject @entries, ((sum, entry) -> sum + entry.elapsed), 0

      length: ->
        @entries.length

      clear: (options = {}) ->
        ignoreEntry = options["ignore"]
        @deleteMultiple _.reject(@entries, (storedEntry) => storedEntry == ignoreEntry)
        @entries = _.filter(@entries, (storedEntry) => storedEntry == ignoreEntry)

      currentEntry: ->
        _.find(@entries, (storedEntry) => storedEntry.current)

      load:  ->
        deferred = $q.defer()
        that = @
        if !@loaded
          that.adapter.index().then (entries) =>
            if entries
              entries = _.map entries, (entry) ->
                entry.list = that
                new TimerEntry(entry)
              that.entries = entries
              that.loaded = true
              deferred.resolve(that.entries)
        else
          deferred.resolve(@entries)
        deferred.promise

      setQueryData: (queryData) ->
        @queryData = queryData

      query: ->
        deferred = $q.defer()
        that = @
        that.adapter.query(@queryData).then (entries) =>
          if entries
            entries = _.map entries, (entry) ->
              entry.list = that
              new TimerEntry(entry)
            that.entries = entries
            deferred.resolve(that.entries)
        deferred.promise

      save: (entry) ->
        subscriber.onEntrySave(entry) for subscriber in @subscribers
        @adapter.save(entry) if @adapter

      delete: (entry) ->
        @adapter.delete(entry) if @adapter

      deleteMultiple: (entries) ->
        @adapter.clear entries if @adapter

    }

    angular.extend(TimerEntryList.prototype, instanceMethods)

    TimerEntryList
  )
