describe "ZenTimer", ->

  beforeEach module "zen-timer"

  beforeEach module(($provide) ->
    $provide.value "Entry",
      createTempEntry: ->
      totalElapsed: ->
      createNewEntry: ->
      deleteEntry: ->
      clear: ->
      currentEntry: ->
        increment: ->
        start: ->
        pause: ->
        toggle: ->
        running: "running"
        savable: -> "savable"
        save: ->
        current: true
    return undefined
  )

  beforeEach inject (ZenTimer) ->
    ZenTimer.init()

  it "has default values", inject (ZenTimer) ->
    expect(ZenTimer.currentEntry).toBeTruthy()

  it "creates a tempEntry", inject (ZenTimer, Entry) ->
    sinon.stub(Entry, "createTempEntry")
    ZenTimer.createTempEntry()
    sinon.assert.calledOnce(Entry.createTempEntry)

  it "creates a new Entry", inject (ZenTimer, Entry) ->
    sinon.stub(Entry, "createNewEntry")
    ZenTimer.createNewEntry()
    sinon.assert.calledOnce(Entry.createNewEntry)

  it "checks whether the current Entry is running", inject (ZenTimer) ->
    expect(ZenTimer.running()).toEqual("running")

  it "checks whether the current Entry is savable", inject (ZenTimer) ->
    expect(ZenTimer.savable()).toEqual("savable")

  it "starts an entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer.currentEntry, "start")
    ZenTimer.start()
    sinon.assert.calledOnce(ZenTimer.currentEntry.start)

  it "pauses an entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer.currentEntry, "pause")
    ZenTimer.pause()
    sinon.assert.calledOnce(ZenTimer.currentEntry.pause)

  it "toggles an entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer.currentEntry, "toggle")
    ZenTimer.toggle()
    sinon.assert.calledOnce(ZenTimer.currentEntry.toggle)

  it "saves an entry", inject (ZenTimer) ->
    currentEntry = ZenTimer.currentEntry
    sinon.stub(ZenTimer.currentEntry, "save")
    ZenTimer.save()
    sinon.assert.calledOnce(currentEntry.save)

  it "creates a temporary entry when saved", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "createTempEntry")
    ZenTimer.save()
    sinon.assert.calledOnce(ZenTimer.createTempEntry)

  it "continues an entry", inject (ZenTimer) ->
    currentEntry = ZenTimer.currentEntry
    anotherEntry = { start: -> }
    sinon.stub(currentEntry, "pause")
    sinon.stub(anotherEntry, "start")

    ZenTimer.continue(anotherEntry)

    expect(currentEntry.current).toBeFalsy()
    expect(ZenTimer.currentEntry).toEqual(anotherEntry)
    sinon.assert.calledOnce(currentEntry.pause)
    sinon.assert.calledOnce(anotherEntry.start)

  it "deletes the current entry", inject (ZenTimer, Entry) ->
    currentEntry = ZenTimer.currentEntry
    sinon.stub(Entry, "deleteEntry")
    sinon.stub(ZenTimer.currentEntry, "pause")

    ZenTimer.deleteCurrent()

    sinon.assert.calledWith(Entry.deleteEntry, currentEntry)
    sinon.assert.calledOnce(currentEntry.pause)
    expect(ZenTimer.currentEntry != currentEntry).toBeTruthy()

  it "adds a new entry", inject (ZenTimer, Entry) ->
    newEntry = {}
    sinon.stub(Entry, 'createNewEntry')
    ZenTimer.addEntry()
    sinon.assert.calledWith(Entry.createNewEntry, false)

  it "increments the current entry if it is running", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "running").returns(true)
    sinon.stub(ZenTimer.currentEntry, 'increment')
    ZenTimer.increment()
    sinon.assert.called(ZenTimer.currentEntry.increment)

  it "does not increment the current entry if it is not running", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "running").returns(false)
    sinon.stub(ZenTimer.currentEntry, 'increment')
    ZenTimer.increment()
    sinon.assert.notCalled(ZenTimer.currentEntry.increment)

  it "calculates the total elapsed sum", inject (ZenTimer, Entry) ->
    sinon.stub(Entry, 'totalElapsed').returns(10)
    total = ZenTimer.totalElapsed()
    sinon.assert.called(Entry.totalElapsed)
    expect(total).toBe(10)

  it "calculates the total elapsed sum", inject (ZenTimer, Entry) ->
    sinon.stub(Entry, 'clear')
    ZenTimer.clear()
    sinon.assert.called(Entry.clear)





