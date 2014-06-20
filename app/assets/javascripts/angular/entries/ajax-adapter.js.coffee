angular.module("entries").
  service("AjaxAdapter", ($http, $q, user) ->
    AjaxAdapter = {
      save: (entry) ->
        deferred = $q.defer()
        @saveRequest(entry).success (response) =>
          entry.assignOnSave response.entry
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
        $http.post("/entries/filter.json", data).success (response) =>
          deferred.resolve response.entries
        deferred.promise

      queryCsv: (data) ->
        deferred = $q.defer()
        params = {
          "token": data.token
          "query[date_filter][from]": data.query.date_filter.from
          "query[date_filter][to]": data.query.date_filter.to
          "query[date_filter][to]": data.query.date_filter.to
          "query[projects]": data.query.projects
          "query[tags][include]": data.query.tags.include
          "query[tags][exclude]": data.query.tags.exclude
        }
        $http.get("/entries/filter.csv", { params: params })

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

    window.adapter = AjaxAdapter

    AjaxAdapter
  )
