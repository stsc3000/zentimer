angular.module("zen-timer").
  factory("ZenTimer", (Entry) ->
    ZenTimer =
      entries: Entry.entries
      addEntry: Entry.addEntry

      init: ->
        unless @currentEntry
          @currentEntry = Entry.currentEntry()

      createTempEntry: ->
        @currentEntry = Entry.tempEntry()

      createNewEntry: ->
        @currentEntry = Entry.createNewEntry()

      running: ->
        @currentEntry.running

      pause: ->
        @currentEntry.pause()

      start: ->
        @createNewEntry() if @currentEntry.temp
        @currentEntry.start()

      toggle: ->
        @createNewEntry() if @currentEntry.temp
        @currentEntry.toggle()

      savable: ->
        @currentEntry.savable()

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


    window.ZenTimer = ZenTimer
    ZenTimer
  ).run( (ZenTimer) ->
    ZenTimer.init()
  )
