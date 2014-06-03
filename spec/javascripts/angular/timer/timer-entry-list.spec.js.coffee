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

  it "clears entries", inject (TimerEntryList, TimerEntry) ->
    anEntry = new TimerEntry(elapsed: 10)
    anotherEntry = new TimerEntry(elapsed: 20)
    timerEntryList = new TimerEntryList([anEntry, anotherEntry])

    timerEntryList.clear()

    expect(timerEntryList.entries.length).toEqual(0)

  it "clears entries but ignores one", inject (TimerEntryList, TimerEntry) ->
    anEntry = new TimerEntry(elapsed: 10)
    anotherEntry = new TimerEntry(elapsed: 20)
    timerEntryList = new TimerEntryList([anEntry, anotherEntry])

    timerEntryList.clear(ignore: anEntry)

    expect(timerEntryList.entries.length).toEqual(1)

  it "saves using the adapter", inject (TimerEntryList, TimerEntry) ->
    entry = new TimerEntry()
    adapter = { save: -> }
    sinon.stub(adapter, "save")

    timerEntryList = new TimerEntryList([entry], adapter: adapter)
    timerEntryList.save(entry)

    sinon.assert.calledOnce(adapter.save)

  it "informs subscribers if an entry is saved", inject (TimerEntryList, TimerEntry) ->
    entry = new TimerEntry()
    subscriber = { onEntrySave: -> }
    sinon.stub(subscriber, "onEntrySave")

    timerEntryList = new TimerEntryList([entry], subscribers: [subscriber])
    timerEntryList.save(entry)

    sinon.assert.calledOnce(subscriber.onEntrySave)
