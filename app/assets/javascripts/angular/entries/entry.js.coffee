angular.module("entries").
  factory("Entry", ($timeout, LocalStorageAdapter) ->

    defaultAttributes = 
      elapsed: 0
      lastTick: null
      description: ""
      running: false

    Entry = (attributes = {}) ->
      angular.extend(@, defaultAttributes)
      attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
      angular.extend(@, attributes)
      @

    Entry.nowDate = ->
      new Date()

    Entry.prototype = 
      increment: ->
        @now = Entry.nowDate()

        if @lastTick
          difference = ( (@now.getTime() - @lastTick.getTime()) / 1000 )
          @elapsed += difference
        else
          @elapsed += 1

        @lastTick = @now

        Entry.save()

      savable: ->
        @hasRunOnce() && !@running

      start: ->
        @lastTick = Entry.nowDate()
        @current = true
        @running = true
        Entry.addEntry @
        Entry.save()
        @runLoop()

      pause: ->
        @running = false
        Entry.save()

      save: ->
        @current = false
        @pause()

      runLoop: ->
        $timeout ( =>
          console.log("runLoop")
          if @running
            @increment()
            @runLoop()
        ), 1000

      persist: ->
        Entry.save()

      toggle: ->
        if @running then @pause() else @start()

      hasRunOnce: ->
        @elapsed > 0

    Entry.save = ->
      Entry.storage().setItem("entries", JSON.stringify(@entries))


    Entry.load = (callback) ->
      if !@loaded
        Entry.storage().getItem "entries", (entriesJSON) ->
          if entriesJSON
            entries = JSON.parse(entriesJSON)
            entries = _.map(entries, (entry) -> new Entry(entry))
            angular.copy entries, @entries
            @loaded = true
            callback(@entries) if callback

    Entry.createNewEntry = (attributes) ->
      entry = new Entry(attributes)
      @entries.push(entry)
      entry

    Entry.createTempEntry =  (attributes) ->
      return new Entry(attributes)

    Entry.deleteEntry = (entry) ->
      _.remove(@entries, (searchEntry) -> searchEntry == entry)
      @save()

    Entry.addEntry = (entry) ->
      @entries.push(entry) unless _.include(@entries, entry)

    Entry.currentEntry = ->
      Entry.load()
      currentlyRunning = _.find(@entries, (entry) -> entry.current)

      if currentlyRunning
        currentlyRunning.runLoop()
        return currentlyRunning
      else
        Entry.createTempEntry()

    Entry.totalElapsed = ->
      _.inject @entries, ((sum, entry) -> sum + entry.elapsed), 0

    Entry.clear = ->
      currentEntry = @currentEntry()
      @entries.clear()
      @entries[0] = currentEntry
      Entry.save()

    Entry.entries = []

    Entry.storage = ->
      LocalStorageAdapter

    window.entries = Entry.entries
    Entry

  )
