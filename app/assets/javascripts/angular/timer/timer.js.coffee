angular.module("timer").
  factory("Timer", (TimerEntry, TimerEntryList) ->
    Timer = {
      isRunning: -> @entry.isRunning()
      isPaused: -> @entry.isPaused()
      entryIsStoppable: -> @entry.isStoppable()

      init: ->
        @entries = new TimerEntryList()
        @setNewEntry()

      stop: ->
        @entry.stop()
        @setNewEntry()

      continue: (entry) ->
        @pause()
        @entry = entry
        @start()

      start: -> @entry.start()
      pause: -> @entry.pause()

      setNewEntry: ->
        @setEntry new TimerEntry() 

      toggle: ->
        if @isRunning()
          @pause()
        else
          @start()

      setEntry: (entry) ->
        @entry = entry
        @entries.store entry

      removeEntry: ->
        @entries.remove(@entry)
        @setNewEntry()


    }

    Timer.init()

    Timer
  )

