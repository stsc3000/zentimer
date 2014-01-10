angular.module("zen-timer").
  factory("ZenTimer", (Entry) ->
    ZenTimer =
      entries: Entry.entries
      addEntry: Entry.addEntry

      init: ->
        unless @currentEntry
          @currentEntry = Entry.currentEntry()

      createTempEntry: ->
        @currentEntry = Entry.createTempEntry()

      createNewEntry: ->
        @currentEntry = Entry.createNewEntry()

      running: ->
        @currentEntry.running

      savable: ->
        @currentEntry.savable()

      start: ->
        @currentEntry.start()

      pause: ->
        @currentEntry.pause()

      toggle: ->
        @currentEntry.toggle()

      save: ->
        @currentEntry.save()
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
        @currentEntry.increment()


    window.ZenTimer = ZenTimer
    ZenTimer
  )
