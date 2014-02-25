angular.module("settings").
  service("LocalStorageSettingsAdapter", ($q) ->
    {
      save: (key, value) ->
        deferred = $q.defer()
        @ensureKey(key)
        @setSetting(key, value)
        deferred.resolve(value)
        deferred.promise

      fetch: (key) ->
        deferred = $q.defer()
        @ensureKey(key)
        @[key] ||= @fetchValue(key)
        deferred.resolve @[key]
        deferred.promise

      fetchValue: (key)->
        JSON.parse(window.localStorage.getItem("settings"))[key]

      setSetting: (key, value) ->
        settings = JSON.parse window.localStorage.getItem("settings")
        settings[key] = value
        window.localStorage.setItem("settings", JSON.stringify(settings))

      ensureKey: (key) ->
        unless window.localStorage.getItem("settings")
          window.localStorage.setItem("settings", JSON.stringify({}))

        unless JSON.parse(window.localStorage.getItem("settings"))[key]
          @setSetting(key, [])

    }
  )
