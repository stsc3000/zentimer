angular.module("settings").
  service("Tags", (user, LocalStorageSettingsAdapter) ->
    {
      tags: ->
        @storage().fetch("tags")

      save: (tags) ->
        @storage().save("tags", tags)

      storage: ->
        LocalStorageSettingsAdapter

    }

  )
