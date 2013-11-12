angular.module("entries").
  factory("Entry", ->

    defaultAttributes = 
      elapsed: 0
      description: ""
      running: false
      runningSince: null

    Entry = (attributes) ->
      angular.extend(@, defaultAttributes)
      angular.extend(@, attributes)
      if @runningSince
        now = new Date
        before = new Date(@runningSince)
        @elapsed += Math.floor(now.getTime() / 1000)  - Math.floor( before.getTime() / 1000)
        @runningSince = now
      @

    Entry.prototype = 
      increment:  (seconds = 1) ->
        @runningSince = new Date
        @elapsed += seconds
        Entry.save()

      savable: ->
        @elapsed > 0 && !@running

      start: ->
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

    Entry.deleteEntry = (entry) ->
      _.remove(@entries, (searchEntry) -> searchEntry == entry)
      @save()

    Entry.currentEntry = ->
      Entry.load()
      currentlyRunning = _.find(@entries, (entry) -> entry.current)
      if currentlyRunning
        return currentlyRunning
      else
        newEntry = new Entry({current: true})
        @entries.push(newEntry)
        return newEntry



    Entry.entries = []

    Entry

  )
