angular.module("timer").
  factory("TimerService", ($timeout, Entry) ->
    TimerService =
      currentEntry: (new Entry)

      running: ->
        @currentEntry.running

      setEntry: (entry) ->
        @currentEntry = entry

      start: ->
        @currentEntry.start()

      pause: -> 
        @currentEntry.pause()

      continue: (entry) ->
        @pause()
        @setEntry(entry)
        @start()

      save: ->
        @pause()
        Entry.save(@currentEntry)
        @setEntry(Entry.newEntry())

      runLoop: ->
        $timeout ( =>
          if @running()
            @currentEntry.increment()
          @runLoop()
        ),1000
      init: ->
        Entry.fetch().then (entries) =>
          currentEntry = _.find entries, (entry) -> entry.running
          @currentEntry = currentEntry if currentEntry
        @runLoop()

    TimerService
  )
