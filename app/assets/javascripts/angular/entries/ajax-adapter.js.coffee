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

      query: (data) ->
        deferred = $q.defer()
        $http.post("/entries/filter", data).success (response) =>
          deferred.resolve response.entries
        deferred.promise

      delete: (entry) ->
        deferred = $q.defer()
        $http.delete("/entries/#{entry.id}?token=#{user.token}").success (response) =>
          deferred.resolve response
        deferred.promise

      clear: (entries) ->
        deferred = $q.defer()
        data =
          "ids[]": _.map entries, (entry) -> entry.id
        $http.delete("/entries?token=#{user.token}", { params: data }).success (response) =>
          deferred.resolve response
        deferred.promise

    }
  )
