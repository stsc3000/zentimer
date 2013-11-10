angular.module("entries").
  factory("Entry", ->
    Entry = ->
      elapsed: 0
      description: ""
      increment: ->
        @elapsed += 1
      savable: ->
        @elapsed > 0

  )
