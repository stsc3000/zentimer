angular.module("timer")
  .factory("TimerEntryList", ($q, TimerEntry) ->
    TimerEntryList = (entries, options = {})->
      @entries = entries || []
      @adapter = options.adapter

      @onSave = options.onSave || []
      @onIncrement = options.onIncrement || []
      @onStart = options.onStart || []
      @onStop = options.onStop || []

      @linkEntry(entry) for entry in @entries

      @

    instanceMethods = {

      linkEntry: (entry) ->
        entry.list = @
        entry.onIncrement = @onIncrement
        entry.onStart = @onStart
        entry.onStop = @onStop

      includes: (entry) ->
        _.include @entries, entry

      store: (entry) ->
        @linkEntry(entry)
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
                timerEntry = new TimerEntry(entry)
                that.linkEntry(timerEntry)
                timerEntry
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
              timerEntry = new TimerEntry(entry)
              that.linkEntry(timerEntry)
              timerEntry
            that.entries = entries
            deferred.resolve(that.entries)
        deferred.promise

      queryCsvUrl: ->
        @adapter.queryCsvUrl(@queryData)

      save: (entry) ->
        if entry.isValid()
          subscriber(entry) for subscriber in @onSave
          @adapter.save(entry) if @adapter
        else
          _.remove @entries, (searchEntry) -> searchEntry == entry

      delete: (entry) ->
        @adapter.delete(entry) if @adapter

      deleteMultiple: (entries) ->
        @adapter.clear entries if @adapter

    }

    angular.extend(TimerEntryList.prototype, instanceMethods)

    TimerEntryList
  )
