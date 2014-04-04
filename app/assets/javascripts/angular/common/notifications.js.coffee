angular.module("app").
  service("Notifications", ($interval) ->
    {
      interval: null
      start: (entry) ->
        Notification.requestPermission()
        @interval = $interval ( =>
          @notify(entry)
        ), 1000
      stop: (entry) ->
        $interval.cancel(@interval) if @interval
      notify: (entry) ->
        console.log "notify!"
    }
  )
