angular.module("tags").
  service("Tags", (user, LocalStorageTagsAdapter) ->
    {
      tags: ->
        @storage().index()

      save: (tags) ->
        @storage().save(tags)

      storage: ->
        LocalStorageTagsAdapter

    }

  )
