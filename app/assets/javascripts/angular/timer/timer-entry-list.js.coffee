angular.module("timer")
  .factory("TimerEntryList", ->
    TimerEntryList = ->
      @entries = []
      @

    instanceMethods = {
      includes: (entry) ->
        _.include @entries, entry
      store: (entry) ->
        @entries.push(entry)
      remove: (entry) ->
        _.remove @entries, (storedEntry) -> storedEntry == entry
    }

    angular.extend(TimerEntryList.prototype, instanceMethods)

    TimerEntryList
  )
