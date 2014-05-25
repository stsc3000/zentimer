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
