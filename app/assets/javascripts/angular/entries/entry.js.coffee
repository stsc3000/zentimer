angular.module("entries").
  factory("Entry", ->

    defaultAttributes = 
      elapsed: 0
      lastTick: null
      description: ""
      running: false
      runningSince: null

    Entry = (attributes = {}) ->
      angular.extend(@, defaultAttributes)
      attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
      angular.extend(@, attributes)
      @

    Entry.nowDate = ->
      new Date()

    Entry.prototype = 
      increment:  (seconds = 1) ->
        @runningSince = Entry.nowDate()
        @now = Entry.nowDate()

        if @lastTick
          difference = Math.floor( (@now.getTime() - @lastTick.getTime()) / 1000 )
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

      pause: ->
        @running = false
        @runningSince = false
        Entry.save()

      save: ->
        @current = false
        @pause()

      persist: ->
        Entry.save()

      toggle: ->
        if @running then @pause() else @start()

      hasRunOnce: ->
        @elapsed > 0

    Entry.save = ->
      Entry.storage().setItem("entries", JSON.stringify(@entries))

    Entry.load = ->
      if (entriesJSON = Entry.storage().getItem("entries"))
        entries = JSON.parse(entriesJSON)
        entries = _.map(entries, (entry) -> new Entry(entry))
        angular.copy entries, @entries

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
        return currentlyRunning
      else
        Entry.createTempEntry()

    Entry.totalElapsed = ->
      _.inject @entries, ((sum, entry) -> sum + entry.elapsed), 0

    Entry.entries = []

    Entry.storage = ->
      localStorage

    Entry

  )
