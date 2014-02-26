angular.module("settings").
  service("Settings", (user, LocalStorageSettingsAdapter, AjaxSettingsAdapter) ->
    {
      tags: ->
        @storage().fetch("tags")

      saveTags: (tags) ->
        @storage().save("tags", tags)

      projects: ->
        @storage().fetch("projects")

      saveProjects: (projects) ->
        @storage().save("projects", projects)

      storage: ->
        if user
          AjaxSettingsAdapter
        else
          LocalStorageSettingsAdapter

    }

  )
