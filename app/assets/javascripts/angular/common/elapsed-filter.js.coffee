angular.module("app")
  .filter('elapsed', ->
    pad = (n, width) ->
      z = "0"
      n = n + ""
      (if n.length >= width then n else new Array(width - n.length + 1).join(z) + n)

    (input) ->
      if input
        hours = pad Math.floor( input / Math.pow( 60, 2 ) ), 2
        minutes = pad Math.floor( input / 60 ) % 60, 2
        seconds = pad Math.floor( input % 60 ), 2
      else
        hours = minutes = seconds = "00"

      result = ""
      result += "#{hours}:" if hours != "00"
      result += "#{minutes}:#{seconds}"
      result

  )
