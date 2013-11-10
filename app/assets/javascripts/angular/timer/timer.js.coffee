angular.module("timer").
  factory("Timer", ($timeout, ZenTimer) ->

    Timer=
      runLoop: ->
        $timeout ( =>
          if ZenTimer.running()
            ZenTimer.currentEntry.increment()
          @runLoop()
        ),1000

    window.Timer = Timer
    Timer
  ).run( (Timer) -> Timer.runLoop() )
