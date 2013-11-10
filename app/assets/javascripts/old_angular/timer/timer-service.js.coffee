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

      toggle: ->
        if @running()
          @pause()
        else
          @start()

      continue: (entry) ->
        @pause()
        @setEntry(entry)
        @start()

      delete: (entry) ->
        if @currentEntry == entry
          @currentEntry.willBeDeleted()
          @currentEntry = new Entry
        Entry.delete(entry)


      save: ->
        console.log("save", @currentEntry)
        @pause()
        Entry.save(@currentEntry)
        @setEntry(Entry.newEntry())

      runLoop: ->
        $timeout ( =>
          if @running() && !@blocked
            @currentEntry.increment()
          else
            console.log("not running!")
          @runLoop()
        ),1000

      init: ->
        Entry.fetch().then (entries) =>
          currentEntry = _.find entries, (entry) -> entry.running
          @currentEntry = currentEntry if currentEntry
        @runLoop()

    TimerService
  )
