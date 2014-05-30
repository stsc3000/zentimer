angular.module("timer")
  .factory("TimerEntryList", ($q, TimerEntry) ->
    TimerEntryList = (entries, options = {})->
      @entries = entries || []
      @adapter = options["adapter"]
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

      save: (entry) ->
        @adapter.save(entry) if @adapter

      delete: (entry) ->
        @adapter.delete(entry) if @adapter

      deleteMultiple: (entries) ->
        @adapter.clear entries if @adapter

    }

    angular.extend(TimerEntryList.prototype, instanceMethods)

    TimerEntryList
  )
