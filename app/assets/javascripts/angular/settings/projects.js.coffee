angular.module("settings").
  service("Projects", (user, LocalStorageSettingsAdapter) ->
    {
      projects: ->
        @storage().fetch("projects")

      save: (projects) ->
        @storage().save("projects", projects)

      storage: ->
        LocalStorageSettingsAdapter

    }

  )
