angular.module("entries").
  factory("Entry", ($timeout, LocalStorageAdapter, AjaxAdapter, user, Title) ->

    defaultAttributes = ->
      elapsed: 0
      lastTick: null
      tag_list: []
      running: false
      project: ""
      temp: false

    Entry = (attributes = {}) ->
      angular.extend(@, defaultAttributes())
      attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
      angular.extend(@, attributes)

      if @lastTick && @running
        @beforeTick()
        @updateLastTickDifference()
        @tickDone(@now)

      @

    Entry.nowDate = ->
      new Date()

    Entry.prototype = 
      toJSON: ->
        elapsed: @elapsed
        lastTick: @lastTick
        tag_list: @tag_list
        current: @current
        running: @running
        project: @project
        id: @id

      assign: (attributes) ->
        attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
        _.assign(@, attributes)

      beforeTick: ->
        @now = Entry.nowDate()

      tickDone: (now) ->
        @lastTick = now

      increment: ->
        @beforeTick()

        if @lastTick
          @updateLastTickDifference()
        else
          @elapsed += 1

        Title.set(@elapsed)

        @tickDone(@now)

      updateLastTickDifference: ->
        difference = ( (@now.getTime() - @lastTick.getTime()) / 1000 )
        @elapsed += difference

      savable: ->
        @hasRunOnce() && !@running

      persistable: ->
        !this.temp

      start: ->
        @temp = false
        @lastTick = Entry.nowDate()
        @current = true
        @running = true
        Entry.addEntry @
        Entry.save(@)
        @runLoop()

      pause: ->
        @running = false
        Title.set()
        Entry.save(@)

      done: ->
        @current = false
        @pause()

      runLoop: ->
        $timeout ( =>
          if @running
            @increment()
            @runLoop()
        ), 1000

      persist: ->
        Entry.save(@)

      toggle: ->
        if @running then @pause() else @start()

      hasRunOnce: ->
        @elapsed > 0

    Entry.save = (entry) ->
      Entry.storage().save(entry) if entry.persistable()

    Entry.load = (callback) ->
      that = @
      if !@loaded
        Entry.storage().index().then (entries) =>
          if entries
            entries = _.map(entries, (entry) -> new Entry(entry))
            angular.copy entries, that.entries
            that.loaded = true
            callback(@entries) if callback
      else
        callback(@entries) if callback

    Entry.createNewEntry = (attributes) ->
      entry = new Entry(attributes)
      @entries.push(entry)
      Entry.save(entry)
      entry

    Entry.createTempEntry =  (attributes = {}) ->
      attributes.temp = true
      return new Entry(attributes)

    Entry.deleteEntry = (entry) ->
      Entry.storage().delete(entry)
      _.remove(@entries, (searchEntry) -> searchEntry == entry)

    Entry.addEntry = (entry) ->
      @entries.push(entry) unless _.include(@entries, entry)

    Entry.currentEntry = (callback) ->
      Entry.load =>
        currentlyRunning = Entry.currentlyRunning()

        if currentlyRunning
          currentlyRunning.runLoop()
          currentEntry = currentlyRunning
        else
          currentEntry = Entry.createTempEntry()
        callback(currentEntry)

    Entry.currentlyRunning = ->
      _.find(@entries, (entry) -> entry.current)

    Entry.totalElapsed = ->
      _.inject @entries, ((sum, entry) -> sum + entry.elapsed), 0

    Entry.clear = ->
      that = @
      currentlyRunning = Entry.currentlyRunning()
      Entry.storage().clear().then =>
        that.entries.clear()
        if currentlyRunning
          that.entries[0] = currentlyRunning if currentlyRunning
          currentlyRunning.persist()

    Entry.entries = []

    Entry.storage = ->
      if user
        AjaxAdapter
      else
        LocalStorageAdapter

    window.entries = Entry.entries
    Entry

  )
