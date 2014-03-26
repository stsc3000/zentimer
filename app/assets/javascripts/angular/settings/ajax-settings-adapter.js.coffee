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

    }
  )
