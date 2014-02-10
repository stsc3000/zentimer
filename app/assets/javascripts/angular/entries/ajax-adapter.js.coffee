angular.module("entries").
  service("AjaxAdapter", ($http, user) ->
    {
      getItem: (key, callback) ->
        $http.get("/#{user.token}.json").success (response) ->
          callback JSON.parse(response[key])

      setItem: (key, value, callback) ->
        data = {}
        data[key] = value
        $http.put("/#{user.token}", data).success (response) ->
          callback(response) if callback
    }
  )
