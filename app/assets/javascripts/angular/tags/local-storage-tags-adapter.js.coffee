angular.module("tags").
  service("LocalStorageTagsAdapter", ($q) ->
    {
      save: (tags) ->
        deferred = $q.defer()
        @ensureTags()
        window.localStorage.setItem "tags", JSON.stringify(tags)
        deferred.resolve(tags)
        deferred.promise

      index: ->
        deferred = $q.defer()
        @ensureTags()
        deferred.resolve @fetchTags()
        deferred.promise

      fetchTags: ->
        JSON.parse(window.localStorage.getItem("tags"))

      ensureTags: ->
        unless window.localStorage.getItem("tags")
          window.localStorage.setItem("tags", JSON.stringify([]))

    }
  )
