angular.module("tags").
  service("Tag", (user) ->
    {
      tags: ->
        @tags ||= @fetchTags()

      fetchTags: ->
        LocalStorageTagAdaper

    }

  )
