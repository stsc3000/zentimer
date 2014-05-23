describe "ZenTimer", ->
  beforeEach module("timer")

  it "is initialized with a new entry", inject (Timer) ->
    expect(Timer.entry.isNew()).toEqual(true)

  it "starts its entry", inject (Timer) ->
    Timer.start()
    expect(Timer.isRunning()).toEqual(true)

  it "pauses its entry", inject (Timer) ->
    Timer.start()
    Timer.pause()
    expect(Timer.isPaused()).toEqual(true)

  it "pauses an entry and sets a new one when done", inject (Timer) ->
    oldEntry = Timer.entry
    Timer.stop()
    expect(Timer.entry == oldEntry).toBeFalsy()
    expect(oldEntry.isPaused()).toEqual(true)

  it "pauses and entry and continues a given one", inject (Timer, TimerEntry) ->
    newEntry = new TimerEntry()
    Timer.continue(newEntry)

    expect(Timer.entry == newEntry).toBeTruthy()
    expect(Timer.isRunning()).toBeTruthy()

  it "stores its entries in its entry list", inject (Timer) ->
    entry = Timer.entry
    expect(Timer.entries.includes(entry)).toBeTruthy()
