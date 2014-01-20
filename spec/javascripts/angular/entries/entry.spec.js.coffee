describe "Entry", ->
  beforeEach module("entries")

  beforeEach ->
    localStorage.clear()

  it "creates a new Entry with default instance values", inject (Entry) ->
    entry = new Entry
    expect(entry.elapsed).toBe(0)
    expect(entry.description).toBe("")
    expect(entry.lastTick).toBeFalsy()
    expect(entry.running).toBeFalsy()
    expect(entry.runningSince).toBeFalsy()

  it "creates a new Entry with a date as last tick", inject (Entry) ->
    entry = new Entry(lastTick: "2012,12,12")
    expect(entry.lastTick).toEqual(new Date("2012,12,12"))

  it "increments a new Entry by a second", inject (Entry) ->
    entry = new Entry
    expect(entry.elapsed).toEqual(0)
    entry.increment()
    expect(entry.elapsed).toEqual(1)

  it "increments an existing Entry by the difference from its lastTick and now", inject (Entry) ->
    entry = new Entry(lastTick: "2012,12,12 12:00")
    sinon.stub(Entry, "nowDate").returns(new Date("2012,12,12 12:01"))
    expect(entry.elapsed).toEqual(0)
    entry.increment()
    expect(entry.elapsed).toEqual(60)

  it "sets the lastTick to the currentTime after incrementing", inject (Entry) ->
    sinon.stub(Entry, "nowDate").returns(new Date("2012,12,12 12:00"))
    entry = new Entry
    entry.increment()
    expect(entry.lastTick).toEqual(new Date("2012,12,12 12:00"))

  it "sets the runningSince value to the currentTime after incrementing", inject (Entry) ->
    sinon.stub(Entry, "nowDate").returns(new Date("2012,12,12 12:00"))
    entry = new Entry
    entry.increment()
    expect(entry.runningSince).toEqual(new Date("2012,12,12 12:00"))

  it "is savable when it has run once but is not running", inject (Entry) ->
    entry = new Entry
    entry.running = true
    expect(entry.savable()).toBeFalsy()
    entry.increment()
    expect(entry.savable()).toBeFalsy()
    entry.running = false
    expect(entry.savable()).toBeTruthy()

  it "starts an entry and saves all entries", inject (Entry) ->
    sinon.stub(Entry, 'save')
    sinon.stub(Entry, 'addEntry')

    entry = new Entry
    entry.start()

    expect(entry.current).toBeTruthy()
    expect(entry.running).toBeTruthy()
    sinon.assert.calledOnce(Entry.save)
    sinon.assert.calledWith(Entry.addEntry, entry)

  it "pauses an entry", inject (Entry) ->
    sinon.stub(Entry, 'save')

    entry = new Entry(running: true, runningSince: "whatever")
    entry.pause()

    expect(entry.running).toBeFalsy()
    expect(entry.runningSince).toBeFalsy()
    sinon.assert.calledOnce(Entry.save)

  it "persists itself", inject (Entry) ->
    sinon.stub(Entry, 'save')
    entry = new Entry

    entry.persist()

    sinon.assert.calledOnce(Entry.save)

  it "toggles itself to paused if it is running", inject (Entry) ->
    entry = new Entry(running: true)

    entry.toggle()

    expect(entry.running).toBeFalsy()

  it "toggles itself to start if it is not running", inject (Entry) ->
    entry = new Entry(running: false)

    entry.toggle()

    expect(entry.running).toBeTruthy()

  it "increments its elapsed value", inject (Entry) ->
    entry = new Entry
    entry.increment()
    expect(entry.elapsed).toBe(1)

  it "knows when it has run", inject (Entry) ->
    entry = new Entry
    expect(entry.hasRunOnce()).toBeFalsy()
    entry.elapsed = 1
    expect(entry.hasRunOnce()).toBeTruthy()

  it "saves entries to localStorage", inject (Entry) ->
    storage = { setItem: ->  }
    sinon.stub(storage, 'setItem')
    sinon.stub(Entry, 'storage').returns(storage)
    Entry.entries = [{description: "an Entry"}]

    Entry.save()

    sinon.assert.calledWith(storage.setItem, "entries", '[{"description":"an Entry"}]')

  it "does not load entries if there are none", inject (Entry) ->
    storage = { getItem: -> undefined }
    sinon.stub(Entry, 'storage').returns(storage)

    Entry.load()

    expect(Entry.entries).toEqual([])

  it "does load entries from localStorage", inject (Entry) ->
    entriesJSON = JSON.stringify [description: "an entry"]
    storage = { getItem: -> entriesJSON }
    sinon.stub(Entry, 'storage').returns(storage)

    expect(Entry.entries).toEqual([])
    Entry.load()
    expect(Entry.loaded).toBeTruthy()

    expect(Entry.entries.length).toEqual(1)

  it "doesnt load if it has already loaded", inject (Entry) ->
    Entry.loaded = true
    entriesJSON = JSON.stringify [description: "an entry"]
    storage = { getItem: -> entriesJSON }
    sinon.stub(Entry, 'storage').returns(storage)

    expect(Entry.entries).toEqual([])
    Entry.load()
    expect(Entry.entries).toEqual([])

  it "creates a new Entry and pushes it to its collection", inject (Entry) ->
    entry = Entry.createNewEntry description: "an entry"
    expect(Entry.entries[0]).toEqual(entry)

  it "creates a new Entry and does not push it to its collection", inject (Entry) ->
    entry = Entry.createTempEntry description: "an entry"
    expect(Entry.entries).toEqual([])

  it "deletes an entry", inject (Entry) ->
    entry = Entry.createNewEntry description: "an entry"
    sinon.stub(Entry, 'save')
    expect(Entry.entries[0]).toEqual(entry)

    Entry.deleteEntry(entry)

    expect(Entry.entries).toEqual([])
    sinon.assert.calledOnce(Entry.save)

  it "adds a new Entry to the collection", inject (Entry) ->
    entry = Entry.createTempEntry description: "an entry"
    expect(Entry.entries).toEqual([])

    Entry.addEntry(entry)

    expect(Entry.entries[0]).toEqual(entry)

  it "does not add a new Entry to the collection if its already in there", inject (Entry) ->
    entry = Entry.createNewEntry description: "an entry"
    expect(Entry.entries.length).toEqual(1)

    Entry.addEntry(entry)

    expect(Entry.entries.length).toEqual(1)

  it "loads and gets the current Entry", inject (Entry) ->
    sinon.stub(Entry, 'load')
    entry = Entry.createNewEntry description: "an entry", current: true
    expect(Entry.currentEntry()).toEqual(entry)
    sinon.assert.calledOnce(Entry.load)


  it "creates a temporary entry if there is no current Entry", inject (Entry) ->
    sinon.stub(Entry, 'load')
    entry = Entry.createNewEntry description: "an entry", current: false
    expect(Entry.currentEntry()).not.toEqual(entry)

  it "starts with empty entries", inject (Entry) ->
    expect(Entry.entries).toEqual([])

  describe "batch action", ->
    beforeEach inject (Entry) ->
      an_entry = Entry.createNewEntry description: "an entry", elapsed: 10
      another_entry = Entry.createNewEntry description: "an entry", elapsed: 20
      another_entry = Entry.createNewEntry description: "an entry", elapsed: 10, current: true

    it "calculates the total elapsed of entries", inject (Entry) ->
      expect(Entry.totalElapsed()).toBe(40)

    it "clears all entries but the current one", inject (Entry) ->
      sinon.stub(Entry, 'save')
      expect(Entry.entries.length).toBe(3)

      Entry.clear()

      expect(Entry.entries.length).toBe(1)
      sinon.assert.calledOnce(Entry.save)






