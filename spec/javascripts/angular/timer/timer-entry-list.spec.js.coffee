describe "TimerEntryList", ->
  beforeEach module("timer")

  it "stores entries", inject (TimerEntryList, TimerEntry) ->
    entry = new TimerEntry()
    timerEntryList = new TimerEntryList()
    timerEntryList.store(entry)
    expect(timerEntryList.includes(entry)).toBeTruthy()

  it "removes entries", inject (TimerEntryList, TimerEntry) ->
    entry = new TimerEntry()
    timerEntryList = new TimerEntryList()
    timerEntryList.store(entry)
    timerEntryList.remove(entry)
    expect(timerEntryList.includes(entry)).toBeFalsy()

  it "calculates the total elapsed", inject (TimerEntryList, TimerEntry) ->
    anEntry = new TimerEntry(elapsed: 10)
    anotherEntry = new TimerEntry(elapsed: 20)
    timerEntryList = new TimerEntryList([anEntry, anotherEntry])

    expect(timerEntryList.total()).toEqual(30)


