angular.module("zen-timer").
  factory("ZenTimer", (Entry) ->
    ZenTimer =
      entries: Entry.entries
      addEntry: Entry.addEntry

      init: ->
        unless @currentEntry
          @currentEntry = Entry.currentEntry()

      createNewEntry: ->
        @currentEntry = Entry.createNewEntry()

      running: ->
        @currentEntry.running

      pause: ->
        @currentEntry.pause()

      start: ->
        @currentEntry.start()

      toggle: ->
        @currentEntry.toggle()

      savable: ->
        @currentEntry.savable()

      save: ->
        @currentEntry.save()
        @createNewEntry()

      continue: (entry) ->
        @currentEntry = entry
        @start()

      delete: (entry) ->
        if entry == @currentEntry
          @pause()
          @createNewEntry()
        Entry.deleteEntry(entry)


    window.ZenTimer = ZenTimer
    ZenTimer
  ).run( (ZenTimer) ->
    ZenTimer.init()
  )
