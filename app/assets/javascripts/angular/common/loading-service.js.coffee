angular.module("app").
  service("Loading", ($rootScope) ->
    Loading = {
      onLoad: ->
      onLoaded: ->
      subscribe: (options) ->
        @onLoad = options.onLoad
        @onLoaded = options.onLoaded
      wrap: (promise) ->
        $rootScope.menuVisible = false
        @onLoad()
        promise.then => @onLoaded()
        promise
    }

    Loading
  )
