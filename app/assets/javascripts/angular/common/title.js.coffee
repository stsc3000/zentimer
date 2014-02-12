angular.module("app").
  service("Title", () ->
    {
      pad: (n, width) ->
        z = "0"
        n = n + ""
        (if n.length >= width then n else new Array(width - n.length + 1).join(z) + n)

      format: (elapsed) ->
        hours = @pad Math.floor( elapsed / Math.pow( 60, 2 )), 2
        minutes = @pad Math.floor( elapsed / 60 ) % 60, 2
        seconds = @pad Math.floor(elapsed % 60), 2
        "#{hours}:#{minutes}:#{seconds}"
      set: (value) ->
        if value
          document.title = "ZenTimer - #{@format(value)}"
        else
          document.title = "ZenTimer"
    }
  )
