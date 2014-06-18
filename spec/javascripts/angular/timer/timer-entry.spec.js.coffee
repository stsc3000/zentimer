describe "TimerEntry", ->
  beforeEach module("timer")

  it "increments an entry", inject (TimerEntry, $timeout) ->
    entry = new TimerEntry()
    timeSource = sinon.stub(entry, "timeSource")
    timeSource.returns(new Date("2012,12,12 12:00"))

    expect(entry.elapsed).toEqual(0)
    entry.start()
    timeSource.returns(new Date("2012,12,12 12:01"))
    $timeout.flush()
    entry.pause()
    expect(entry.elapsed).toEqual(60)

  it "saves using its list", inject (TimerEntry) ->
    list = { save: -> }
    sinon.stub(list, "save")

    entry = new TimerEntry(list: list)
    entry.save()

    sinon.assert.calledOnce(list.save)

  it "notifies of start and stop", inject (TimerEntry) ->
    notifier =
      start: ->
      stop: ->

    sinon.stub(notifier, "start")
    sinon.stub(notifier, "stop")

    entry = new TimerEntry(onStart: [notifier.start], onStop: [notifier.stop])
    entry.start()
    sinon.assert.calledOnce(notifier.start)
    entry.pause()
    sinon.assert.calledOnce(notifier.stop)

  it "notifies of incrementation", inject (TimerEntry, $timeout) ->
    notifier =
      onIncrement: ->

    sinon.stub(notifier, "onIncrement")

    entry = new TimerEntry(onIncrement: [notifier.onIncrement])
    entry.start()
    $timeout.flush()
    entry.pause()
    sinon.assert.calledOnce(notifier.onIncrement)

  it "assigns elapsed on start correctly", inject (TimerEntry) ->
    now = new Date()
    entry = new TimerEntry(lastTick: now.toString() )
    entry.running = true
    timeSource = sinon.stub(entry, "timeSource")
    timeSource.returns(now)

    expect(parseInt(entry.elapsed)).toEqual(0)

  it "assigns elapsed when running correctly", inject (TimerEntry) ->
    timeItWasSaved = new Date(2012,12,12,12,0,0)
    elapsedWhenItWasSaved = 0

    timeSaveRequestReturns = new Date(2012,12,12,12,0,10)
    elapsedWhenSaveRequestReturns = 10

    entry = new TimerEntry
    entry.elapsed = elapsedWhenSaveRequestReturns
    entry.running = true
    entry.lastTick = timeSaveRequestReturns
    timeSource = sinon.stub(entry, "timeSource")
    timeSource.returns(timeSaveRequestReturns)

    entry.assign
      lastTick: timeItWasSaved
      elapsed: elapsedWhenItWasSaved

    expect(parseInt(entry.elapsed)).toEqual(10)



