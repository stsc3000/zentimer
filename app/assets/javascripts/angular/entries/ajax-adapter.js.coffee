angular.module("entries").
  service("AjaxAdapter", ($http, user) ->
    {
      getItem: (key, callback) ->
        item = window.localStorage.getItem(key)
        callback(item) if callback

      setItem: (key, value, callback) ->
        data = {}
        data[key] = value
        $http.put("/#{user.token}", data).success (response) ->
          callback(response) if callback
    }
  )
