angular.module("timer").
  factory("Timer", (TimerEntry, TimerEntryList) ->
    Timer = {
      isRunning: -> @entry.isRunning()
      isPaused: -> @entry.isPaused()

      init: ->
        @entries = new TimerEntryList()
        @setNewEntry()

      stop: ->
        @entry.pause()
        @setNewEntry()

      continue: (entry) ->
        @pause()
        @entry = entry
        @start()

      start: -> @entry.start()
      pause: -> @entry.pause()

      setNewEntry: ->
        @entry = new TimerEntry()
        @entries.store(@entry)

    }

    Timer.init()

    Timer
  )

