angular.module("entries").
  service("LocalStorageAdapter", ($q) ->
    {
      save: (entry) ->
        deferred = $q.defer()
        @ensureEntries()
        if entry.id
          @updateEntry(entry)
        else
          @createEntry(entry)

        deferred.resolve(entry)
        deferred.promise

      index: ->
        deferred = $q.defer()
        @ensureEntries()
        deferred.resolve(@fetchEntries())
        deferred.promise

      delete: (entry) ->
        deferred = $q.defer()
        entries = @fetchEntries()
        entries = _.reject entries, (otherEntry) ->
          otherEntry.id == entry.id
        @writeEntries(entries)

        deferred.resolve(entries)
        deferred.promise

      createEntry: (entry) ->
        @assignId(entry)
        entries = @fetchEntries()
        @assignId(entry)
        entries.push(entry.toJSON())
        @writeEntries(entries)

      updateEntry: (entry) ->
        entries = @fetchEntries()
        entryFromStorage = @findEntry(entries, entry)
        _.assign(entryFromStorage, entry.toJSON())
        @writeEntries(entries)

      findEntry: (entries, entry) ->
        _.find entries, (otherEntry) ->
          otherEntry.id == entry.id

      ensureEntries: ->
        unless window.localStorage.getItem("entries")
          window.localStorage.setItem("entries", JSON.stringify([]))

      fetchEntries: ->
        JSON.parse(window.localStorage.getItem("entries"))

      assignId: (entry) ->
        entry.id = (new Date).getTime() unless entry.id

      writeEntries: (entries) ->
        window.localStorage.setItem "entries", JSON.stringify(entries)

      #getItem: (key, callback) ->
        #item = window.localStorage.getItem(key)
        #item = JSON.parse(item) if item
        #callback(item) if callback

      #setItem: (key, value, callback) ->
        #window.localStorage.setItem(key, value)
        #callback() if callback
    }
  )
