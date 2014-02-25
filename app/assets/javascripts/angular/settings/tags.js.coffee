angular.module("settings").
  service("Tags", (user, LocalStorageSettingsAdapter) ->
    {
      tags: ->
        @storage().index("tags")

      save: (tags) ->
        @storage().save("tags", tags)

      storage: ->
        LocalStorageSettingsAdapter

    }

  )
