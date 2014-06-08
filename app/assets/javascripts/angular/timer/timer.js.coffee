angular.module("timer").
  factory("Timer", (TimerEntry, TimerEntryList, user, AjaxAdapter, LocalStorageAdapter, Notifications, Title) ->
    Timer = {
      isRunning: -> @entry.isRunning()
      isPaused: -> @entry.isPaused()
      entryIsStoppable: -> @entry.isStoppable()

      loadEntries: ->
        @entries = @generateTimerEntryList()
        @entries.load().then =>
          @setNewEntry() unless @entry = @entries.currentEntry()

      entriesAdapter: ->
        if user
          AjaxAdapter
        else
          LocalStorageAdapter

      generateTimerEntryList: ->
        onStart = [_.bind(Notifications.start, Notifications)]
        onStop = [_.bind(Notifications.stop, Notifications), _.bind(Title.clear, Title)]
        onIncrement = [_.bind(Title.set, Title)]
        new TimerEntryList [],
          adapter: @entriesAdapter(),
          onStart: onStart,
          onStop: onStop,
          onIncrement: onIncrement

      continue: (entry) ->
        if entry != @entry
          @entry.stop()
          @entry = entry
        @start()

      start: ->
        @entry.start()

      pause: (entry) ->
        (entry || @entry).pause()

      stop: ->
        @entry.stop()
        @setNewEntry()

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

