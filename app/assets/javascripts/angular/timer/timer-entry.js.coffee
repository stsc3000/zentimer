angular.module("timer").
  factory("TimerEntry", ($timeout) ->

    defaultAttributes = ->
      id: null
      running: false
      current: false
      elapsed: 0
      lastTick: null
      description: ""
      project: ""
      tagList: []
      intentional: false
      list: null
      onStart: []
      onStop: []
      onIncrement: []

    TimerEntry = (attributes = {}) ->
      @assign angular.extend(defaultAttributes(), attributes)
      @lastTick = new Date(attributes.lastTick) if @lastTick
      @run() if @running
      @

    instanceMethods = {
      isNew: -> @id == null
      isRunning: -> !!@running
      isPaused: -> !@running
      isStoppable: -> @elapsed > 0 && @isPaused()

      isValid: ->
        @elapsed > 0 || @description || @project || @tagList.length > 0 || @intentional || @running

      start: ->
        @current = true
        @running = true
        @lastTick = @timeSource()
        @save()
        @run()

      run: ->
        @triggerOnStart()
        @updateElapsed()
        @runLoop()

      pause: ->
        @running = false
        @triggerOnStop()
        @save()

      stop: ->
        @pause()
        @current = false
        @save()

      runLoop: ->
        $timeout ( =>
          if @isRunning()
            @increment()
            @runLoop()
        ), 1000

      triggerOnStart: ->
        subscriber(@) for subscriber in @onStart

      triggerOnStop: ->
        subscriber(@) for subscriber in @onStop

      triggerOnIncrement: ->
        subscriber(@) for subscriber in @onIncrement

      assign: (attributes) ->
        attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
        _.assign(@, attributes)

      updateElapsed: ->
        @now = @timeSource()
        difference = ( ( @now.getTime() - @lastTick.getTime()) / 1000 )
        @elapsed += difference
        @lastTick = @now

      increment: ->
        @updateElapsed()
        @triggerOnIncrement()

      timeSource: ->
        new Date()

      save: ->
        @list.save(@) if @list

      toJSON: ->
        elapsed: @elapsed
        lastTick: @lastTick
        tagList: @tagList
        current: @current
        running: @running
        project: @project
        description: @description
        id: @id

    }

    angular.extend(TimerEntry.prototype, instanceMethods)

    TimerEntry

  )
