angular.module("entries").
  factory("Entry", ->

    defaultAttributes = 
      elapsed: 0
      description: ""
      running: false

    Entry = (attributes) ->
      angular.extend(@, defaultAttributes)
      angular.extend(@, attributes)

    Entry.prototype = 
      increment:  (seconds = 1) ->
        @elapsed += seconds
        Entry.save()

      savable: ->
        @elapsed > 0 && !@running

      start: ->
        @running = true
        Entry.save()

      pause: ->
        @running = false
        Entry.save()

      save: ->
        @current = false
        @pause()

      toggle: ->
        @running = !@running
        Entry.save()

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
