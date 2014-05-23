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


