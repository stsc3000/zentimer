angular.module("timer").
  factory("TimerService", ($timeout, Entry) ->
    TimerService =
      currentEntry: null
      running: false
      setEntry: (entry) ->
        @currentEntry = entry
      start: ->
        @running = true
      pause: -> 
        @running = false
      runLoop: ->
        $timeout ( =>
          if @running
            @currentEntry.increment()
          @runLoop()
        ),1000
      init: ->
        Entry.fetch().then (entries) =>
          @currentEntry = _.find entries, (entry) -> entry.running

    TimerService.init()
    TimerService.runLoop()

    TimerService
  )
