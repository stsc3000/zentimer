angular.module("timer").
  factory("Timer", (TimerEntry, TimerEntryList, user, AjaxAdapter, LocalStorageAdapter) ->
    Timer = {
      isRunning: -> @entry.isRunning()
      isPaused: -> @entry.isPaused()
      entryIsStoppable: -> @entry.isStoppable()

      loadEntries: ->
        @entries = new TimerEntryList([], adapter: @entriesAdapter())
        @entries.load().then =>
          @setNewEntry() unless @entry = @entries.currentEntry()

      entriesAdapter: ->
        if user
          AjaxAdapter
        else
          LocalStorageAdapter

      stop: ->
        @entry.stop()
        @setNewEntry()

      continue: (entry) ->
        @pause()
        @entry = entry
        @start()

      start: -> @entry.start()

      pause: (entry) ->
        (entry || @entry).pause()

      setNewEntry: ->
        @setEntry new TimerEntry() 

      toggle: ->
        if @isRunning()
          @pause()
        else
          @start()

      setEntry: (entry) ->
        entry.current = true
        @entry = entry
        @entries.store entry

      removeCurrent: ->
        @remove(@entry)
        @setNewEntry()

      remove: (entry) ->
        @entries.remove(entry)

      totalElapsed: ->
        @entries.total()

      clear: ->
        @entries.clear(ignore: @entry)

      addIntentionalEntry: ->
        entry = new TimerEntry(intentional: true)
        @entries.store(entry)
        entry.save()

    }

    Timer
  )

