angular.module("timer").
  factory("TimerEntry", ($timeout) ->

    defaultAttributes =
      id: null
      running: false
      current: false
      elapsed: 0
      lastTick: null
      description: ""
      project: ""
      tagList: []
      intentional: false

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
        @current = true
        @running = true
        @runLoop()

      pause: -> 
        @running = false

      stop: ->
        @pause()
        @current = false

      runLoop: ->
        $timeout ( =>
          if @isRunning()
            @increment()
            @runLoop()
        ), 1000

      increment: ->
        @now = @timeSource()
        difference = ( ( @now.getTime() - @lastTick.getTime()) / 1000 )
        @elapsed += difference
        @lastTick = @now

      timeSource: ->
        new Date()


    }

    angular.extend(TimerEntry.prototype, instanceMethods)

    TimerEntry

  )
