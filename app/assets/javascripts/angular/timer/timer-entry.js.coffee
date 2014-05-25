angular.module("timer").
  factory("TimerEntry", ($timeout) ->

    defaultAttributes =
      id: null
      running: false
      elapsed: 0
      lastTick: null

    TimerEntry = (attributes = {}) ->
      angular.extend @, defaultAttributes
      angular.extend @, attributes
      @

    instanceMethods = {
      isNew: -> @id == null
      isRunning: -> !!@running
      isPaused: -> !@running
      isStoppable: -> @elapsed > 0 && @isPaused()

      start: -> 
        @lastTick = @timeSource()
        @running = true
        @runLoop()

      pause: -> @running = false

      runLoop: ->
        $timeout ( =>
          if @isRunning()
            @increment()
            @runLoop()
        ), 1000

      increment: ->
        @now = @timeSource()
        difference = ( ( @now.getTime() - @lastTick.getTime()) / 1000 )
        @lastTick = @now
        @elapsed += difference

      timeSource: ->
        new Date()


    }

    angular.extend(TimerEntry.prototype, instanceMethods)

    TimerEntry

  )
