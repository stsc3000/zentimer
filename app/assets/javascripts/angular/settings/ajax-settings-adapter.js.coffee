angular.module("settings").
  service("AjaxSettingsAdapter", ($http, $q, user) ->
    {
      fetch: (key) ->
        deferred = $q.defer()
        @fetchSettings().then (settings) ->
          deferred.resolve settings[key]
        deferred.promise

      fetchSettings: ->
        deferred = $q.defer()
        if @settings
          deferred.resolve @settings
        else
          $http.get("/#{user.token}.json").success (response) =>
            @settings = { tags: response.tags, projects: response.projects }
            deferred.resolve @settings
        deferred.promise

      save: (key, value) ->
        deferred = $q.defer()
        data = { user: {} }
        data.user[key] = value
        $http.put("/#{user.token}.json", data).then (response) ->
          @settings ||= {}
          @settings[key] = response.data[key]
          deferred.resolve @settings[key]
        deferred.promise

      #save: (entry) ->
        #deferred = $q.defer()
        #@saveRequest(entry).success (response) =>
          #entry.assign response.entry
          #deferred.resolve(entry)
        #deferred.promise

      #saveRequest: (entry) ->
        #data = { entry: entry.toJSON(), token: user.token }
        #if entry.id
          #$http.put("/entries/#{entry.id}", data)
        #else
          #$http.post("/entries", data)

      #index: ->
        #deferred = $q.defer()
        #$http.get("/entries?token=#{user.token}").success (response) =>
          #deferred.resolve response.entries
        #deferred.promise

      #delete: (entry) ->
        #deferred = $q.defer()
        #$http.delete("/entries/#{entry.id}?token=#{user.token}").success (response) =>
          #deferred.resolve response
        #deferred.promise

      #clear: ->
        #deferred = $q.defer()
        #$http.delete("/entries?token=#{user.token}").success (response) =>
          #deferred.resolve response
        #deferred.promise

    }
  )
