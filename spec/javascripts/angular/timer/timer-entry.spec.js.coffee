describe "TimerEntry", ->
  beforeEach module("timer")

  it "increments an entry", inject (TimerEntry, $timeout) ->
    entry = new TimerEntry()
    timeSource = sinon.stub(entry, "timeSource")
    timeSource.onCall(0).returns(new Date("2012,12,12 12:00"))
    timeSource.onCall(1).returns(new Date("2012,12,12 12:01"))

    expect(entry.elapsed).toEqual(0)
    entry.start()
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

    entry = new TimerEntry(notifier: notifier)
    entry.start()
    sinon.assert.calledOnce(notifier.start)
    entry.pause()
    sinon.assert.calledOnce(notifier.stop)
