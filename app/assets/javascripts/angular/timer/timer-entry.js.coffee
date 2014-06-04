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
      notifier: null

    TimerEntry = (attributes = {}) ->
      @assign angular.extend(defaultAttributes(), attributes)
      @lastTick = new Date(attributes.lastTick) if @lastTick
      @runLoop() if @running
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
        @save()
        @notifyStart()
        @runLoop()

      pause: ->
        @running = false
        @notifyStop()
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

      notifyStart: ->
        @notifier.start(@) if @notifier

      notifyStop: ->
        @notifier.stop(@) if @notifier

      assign: (attributes) ->
        attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
        _.assign(@, attributes)

      increment: ->
        @now = @timeSource()
        difference = ( ( @now.getTime() - @lastTick.getTime()) / 1000 )
        @elapsed += difference
        @lastTick = @now

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
