angular.module("timer")
  .factory("TimerEntryList", ->
    TimerEntryList = (entries)->
      @entries = entries || []
      @

    instanceMethods = {
      includes: (entry) ->
        _.include @entries, entry
      store: (entry) ->
        @entries.push(entry) unless @includes(entry)
      remove: (entry) ->
        _.remove @entries, (storedEntry) -> storedEntry == entry
      total: ->
        _.inject @entries, ((sum, entry) -> sum + entry.elapsed), 0
      clear: (options = {}) ->
        ignoreEntry = options["ignore"]
        @entries = _.filter(@entries, (storedEntry) => storedEntry == ignoreEntry)

    }

    angular.extend(TimerEntryList.prototype, instanceMethods)

    TimerEntryList
  )
