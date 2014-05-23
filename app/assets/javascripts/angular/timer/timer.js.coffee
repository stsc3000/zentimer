angular.module("timer").
  factory("Timer", (TimerEntry) ->
    Timer = {
      isRunning: -> @entry.isRunning()
      isPaused: -> @entry.isPaused()

      init: ->
        @setNewEntry()

      stop: ->
        @entry.pause()
        @setNewEntry()

      setNewEntry: ->
        @entry = new TimerEntry()

      continue: (entry) ->
        @pause()
        @entry = entry
        @start()


      start: -> @entry.start()
      pause: -> @entry.pause()




    }

    Timer.init()

    Timer
  )

