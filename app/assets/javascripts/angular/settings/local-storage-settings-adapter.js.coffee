angular.module("settings").
  service("LocalStorageSettingsAdapter", ($q) ->
    {
      save: (key, value) ->
        deferred = $q.defer()
        @ensureKey(key)
        window.localStorage.setItem key, JSON.stringify(value)
        deferred.resolve(value)
        deferred.promise

      index: (key) ->
        deferred = $q.defer()
        @ensureKey(key)
        @[key] ||= @fetchValue(key)
        deferred.resolve @[key]
        deferred.promise

      fetchValue: (key)->
        JSON.parse(window.localStorage.getItem(key))

      ensureKey: (key) ->
        unless window.localStorage.getItem(key)
          window.localStorage.setItem(key, JSON.stringify([]))

    }
  )
