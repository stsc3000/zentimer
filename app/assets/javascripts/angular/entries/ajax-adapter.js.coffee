angular.module("entries").
  service("AjaxAdapter", ($http, $q, user) ->
    AjaxAdapter = {
      save: (entry) ->
        deferred = $q.defer()

        timestamp = (new Date).getTime()
        @saving[entry] = timestamp if entry.id

        @saveRequest(entry).success (response) =>
          if !@saving[entry] || @saving[entry] == timestamp
            entry.assignOnSave response.entry
            delete @saving[entry]
          deferred.resolve(entry)
        deferred.promise

      saveRequest: (entry) ->
        data = { entry: entry.toJSON(), token: user.token }
        if entry.id
          $http.put("/entries/#{entry.id}", data)
        else
          $http.post("/entries", data)

      saving: {}

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

      queryCsvUrl: (queryData) ->
        params = [
          "token=#{queryData.token}",
          "query[date_filter][from]=#{queryData.query.date_filter.from}",
          "query[date_filter][to]=#{queryData.query.date_filter.to}",
          "query[projects]=#{queryData.query.projects || []}",
          "query[tags][include]=#{queryData.query.tags.include || []}",
          "query[tags][exclude]=#{queryData.query.tags.exclude || []}",
        ]
        "entries/filter.csv/?#{params.join("&")}"


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
