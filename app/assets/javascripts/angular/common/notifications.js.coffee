angular.module("app").
  service("Notifications", ($interval, Settings, Audio, elapsedFilter) ->
    {
      elapsedFilter: elapsedFilter
      currentNotification: null
      interval: null
      notificationSettings: null
      start: (entry) ->
        Settings.notificationSettings().then (notificationSettings) =>
          @notificationSettings = notificationSettings
          if parseInt(@notificationSettings.notificationInterval)
            @interval = $interval ( =>
              @notify(entry)
            ), @notificationSettings.notificationInterval * 1000 * 60

      stop: (entry) ->
        $interval.cancel(@interval) if @interval

      notify: (entry) ->
        @closeNotification()
        Audio.play('ping') if @notificationSettings.enableAudioNotification
        if @notificationSettings.enableDesktopNotification
          title = "ZenTimer"
          title += " #{entry.project}" if entry.project
          body = ""
          body += "Duration: #{@elapsedFilter(entry.elapsed)}"
          body += "Tags: #{entry.tag_list.join(", ")}\t" if entry.tag_list.length > 0
          @currentNotification = new Notification title,
            body: body

      closeNotification: ->
        @currentNotification.close() if @currentNotification

    }
  )
