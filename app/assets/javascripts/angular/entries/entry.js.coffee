angular.module("entries").
  factory("Entry", ->

    defaultAttributes = 
      elapsed: 0
      lastTick: new Date
      description: ""
      running: false
      runningSince: null

    Entry = (attributes = {}) ->
      angular.extend(@, defaultAttributes)
      attributes.lastTick = new Date(attributes.lastTick) if attributes.lastTick
      angular.extend(@, attributes)
      @

    Entry.prototype = 
      increment:  (seconds = 1) ->
        @runningSince = new Date
        @now = new Date()

        if @lastTick
          difference = Math.floor( (@now.getTime() - @lastTick.getTime()) / 1000 )
          @elapsed += difference
        else
          @elapsed += 1

        @lastTick = @now

        Entry.save()

      savable: ->
        @elapsed > 0 && !@running

      start: ->
        @lastTick = new Date()
        @current = true
        @running = true
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

    Entry.save = ->
      localStorage.setItem("entries", JSON.stringify(@entries))

    Entry.load = ->
      if (entriesJSON = localStorage.getItem("entries"))
        entries = JSON.parse(entriesJSON)
        entries = _.map(entries, (entry) -> new Entry(entry))
        angular.copy entries, @entries

    Entry.createNewEntry = ->
      entry = new Entry
      entry.current = true
      @entries.push(entry)
      entry

    Entry.tempEntry = ->
      return new Entry( temp: true )

    Entry.deleteEntry = (entry) ->
      _.remove(@entries, (searchEntry) -> searchEntry == entry)
      @save()

    Entry.currentEntry = ->
      Entry.load()
      currentlyRunning = _.find(@entries, (entry) -> entry.current)

      if currentlyRunning
        return currentlyRunning
      else
        Entry.tempEntry()

    Entry.entries = []

    Entry

  )
