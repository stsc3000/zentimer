angular.module("zen-timer").
  factory("ZenTimer", (Entry) ->
    ZenTimer =
      entries: Entry.entries
      addEntry: Entry.addEntry

      init: ->
        Entry.currentEntry (currentEntry) =>
          @currentEntry = currentEntry

      createTempEntry: ->
        @currentEntry = Entry.createTempEntry()

      createNewEntry: ->
        @currentEntry = Entry.createNewEntry()

      running: ->
        @currentEntry.running if @currentEntry

      savable: ->
        @currentEntry.savable() if @currentEntry

      start: ->
        @currentEntry.start() if @currentEntry

      pause: ->
        @currentEntry.pause() if @currentEntry

      toggle: ->
        @currentEntry.toggle() if @currentEntry

      done: ->
        @currentEntry.done()
        @createTempEntry()

      continue: (entry) ->
        @pause()
        @currentEntry.current = false
        @currentEntry = entry
        @start()

      deleteCurrent: ->
        @delete(@currentEntry)

      delete: (entry) ->
        if entry == @currentEntry
          @pause()
          @createTempEntry()
        Entry.deleteEntry(entry)

      addEntry: ->
        Entry.createNewEntry(false)

      increment: ->
        if @running()
          @currentEntry.increment()

      totalElapsed: ->
        Entry.totalElapsed()

      clear: ->
        Entry.clear()

      persistCurrentEntry: ->
        @currentEntry.persist() if @currentEntry


    window.ZenTimer = ZenTimer
    ZenTimer
  )
