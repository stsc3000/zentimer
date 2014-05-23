angular.module("timer").
  factory("TimerEntry", () ->

    TimerEntry = ->
      @id = null
      @running = false

    instanceMethods = {
      isNew: -> @id == null
      isRunning: -> !!@running
      isPaused: -> !@running

      start: -> @running = true
      pause: -> @running = false

    }

    angular.extend(TimerEntry.prototype, instanceMethods)

    TimerEntry

  )
