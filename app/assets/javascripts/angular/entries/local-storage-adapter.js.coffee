angular.module("entries").
  service("LocalStorageAdapter", ($q) ->
    {
      save: (entry) ->
        console.log "save", entry
        deferred = $q.defer()
        @ensureEntries()
        if entry.id
          @updateEntry(entry)
        else
          @createEntry(entry)

        deferred.resolve(entry)
        deferred.promise

      index: ->
        console.log "index"
        deferred = $q.defer()
        @ensureEntries()
        deferred.resolve(@fetchEntries())
        deferred.promise

      delete: (entry) ->
        console.log "delete", entry
        deferred = $q.defer()
        entries = @fetchEntries()
        entries = _.reject entries, (otherEntry) ->
          otherEntry.id == entry.id
        @writeEntries(entries)

        deferred.resolve(entries)
        deferred.promise

      clear: ->
        console.log "clear"
        deferred = $q.defer()
        @writeEntries([])
        deferred.resolve(@fetchEntries())
        deferred.promise

      createEntry: (entry) ->
        @assignId(entry)
        console.log "createEntry", entry
        entries = @fetchEntries()
        @assignId(entry)
        entries.push(entry.toJSON())
        @writeEntries(entries)

      updateEntry: (entry) ->
        console.log "updateEntry", entry
        entries = @fetchEntries()
        entryFromStorage = @findEntry(entries, entry)
        console.log "entryFromStorage", entryFromStorage
        unless entryFromStorage
          entryFromStorage = {}
          entries.push entryFromStorage
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
