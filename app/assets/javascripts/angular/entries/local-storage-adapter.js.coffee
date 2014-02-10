angular.module("entries").
  service("LocalStorageAdapter", () ->
    {
      getItem: (key, callback) ->
        item = window.localStorage.getItem(key)
        item = JSON.parse(item) if item
        callback(item) if callback

      setItem: (key, value, callback) ->
        window.localStorage.setItem(key, value)
        callback() if callback
    }
  )
