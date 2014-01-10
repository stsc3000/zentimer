angular.module("timer").
  factory("Timer", ($timeout, ZenTimer) ->

    Timer=
      runLoop: ->
        $timeout ( =>
          ZenTimer.increment()
          @runLoop()
        ),1000

    window.Timer = Timer
    Timer
  ).run( (Timer) -> Timer.runLoop() )
