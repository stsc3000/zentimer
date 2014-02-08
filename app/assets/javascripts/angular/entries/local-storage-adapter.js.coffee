angular.module("entries").
  service("LocalStorageAdapter", () ->
    {
      getItem: (key, callback) ->
        item = window.localStorage.getItem(key)
        callback(item) if callback

      setItem: (key, value, callback) ->
        window.localStorage.setItem(key, value)
        callback() if callback
    }
  )
