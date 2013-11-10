angular.module("zen-timer").
  factory("ZenTimer", (Entry) ->
    ZenTimer =
      running: false
      entries: []

      addEntry: (entry) ->
        @entries.push(entry)

      createNewEntry: ->
        @currentEntry = new Entry
        @addEntry(@currentEntry)

      init: ->
        unless @currentEntry
          @createNewEntry()

      pause: ->
        @running = false

      start: ->
        @running = true

      toggle: ->
        @running = !@running

      savable: ->
        !@running && @currentEntry.savable()

      save: ->
        @createNewEntry()

      continue: (entry) ->
        @currentEntry = entry
        @start()

      delete: (entry) ->
        if entry == @currentEntry
          @pause()
          @createNewEntry()

        _.remove(@entries, (searchEntry) -> searchEntry == entry)

    window.ZenTimer = ZenTimer
    ZenTimer
  ).run( (ZenTimer) ->
    ZenTimer.init()
  )
