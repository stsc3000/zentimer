angular.module("entries").
  service("AjaxAdapter", ($http, $q, user) ->
    {
      save: (entry) ->
        deferred = $q.defer()
        @saveRequest(entry).success (response) =>
          entry.assign response.entry
          deferred.resolve(entry)
        deferred.promise

      saveRequest: (entry) ->
        data = { entry: entry.toJSON(), token: user.token }
        if entry.id
          $http.put("/entries/#{entry.id}", data)
        else
          $http.post("/entries", data)

      index: ->
        deferred = $q.defer()
        $http.get("/entries?token=#{user.token}").success (response) =>
          deferred.resolve response.entries
        deferred.promise

      delete: (entry) ->
        deferred = $q.defer()
        $http.delete("/entries/#{entry.id}?token=#{user.token}").success (response) =>
          deferred.resolve response
        deferred.promise

      clear: ->
        deferred = $q.defer()
        $http.delete("/entries?token=#{user.token}").success (response) =>
          deferred.resolve response
        deferred.promise

    }
  )
