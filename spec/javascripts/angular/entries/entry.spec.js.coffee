describe "Entry", ->
  beforeEach module("entries")

  beforeEach ->
    localStorage.clear()

  beforeEach module(($provide) ->
    $provide.value "user", undefined
    return undefined
  )

  beforeEach module(($provide) ->
    $provide.value "Title", { set: -> }
    return undefined
  )


  it "creates a new Entry with default instance values", inject (Entry) ->
    entry = new Entry
    expect(entry.elapsed).toBe(0)
    expect(entry.description).toBe("")
    expect(entry.lastTick).toBeFalsy()
    expect(entry.running).toBeFalsy()

  it "updates a new Entry to its current elapsed value if there is a last tick", inject (Entry) ->
    sinon.stub(Entry, "nowDate").returns(new Date("2012,12,12 12:01"))
    entry = new Entry(lastTick: "2012,12,12 12:00", running: true)
    expect(entry.elapsed).toEqual(60)


  it "increments a new Entry by a second", inject (Entry) ->
    entry = new Entry
    expect(entry.elapsed).toEqual(0)
    entry.increment()
    expect(entry.elapsed).toEqual(1)

  it "increments an existing Entry by the difference from its lastTick and now", inject (Entry) ->
    nowDate = sinon.stub(Entry, "nowDate")
    nowDate.onCall(0).returns(new Date("2012,12,12 12:00"))
    nowDate.onCall(1).returns(new Date("2012,12,12 12:01"))

    entry = new Entry(lastTick: "2012,12,12 12:00", running: true)

    expect(entry.elapsed).toEqual(0)

    entry.increment()

    expect(entry.elapsed).toEqual(60)

  it "sets the lastTick to the currentTime after incrementing", inject (Entry) ->
    sinon.stub(Entry, "nowDate").returns(new Date("2012,12,12 12:00"))
    entry = new Entry
    entry.increment()
    expect(entry.lastTick).toEqual(new Date("2012,12,12 12:00"))

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

    entry = new Entry(running: true)
    entry.pause()

    expect(entry.running).toBeFalsy()
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

  it "saves entries to storage", inject (Entry) ->
    entry = new Entry
    storage = { save: ->  }
    sinon.stub(storage, 'save')
    sinon.stub(Entry, 'storage').returns(storage)

    Entry.save(entry)

    sinon.assert.calledWith(storage.save, entry)

  it "does load entries from stroage", inject (Entry, $rootScope, $q) ->
    entries = [description: "an entry"]

    deferred = $q.defer()
    deferred.resolve(entries)

    storage = { index: -> deferred.promise }
    sinon.stub(Entry, 'storage').returns(storage)

    expect(Entry.entries).toEqual([])
    Entry.load()
    $rootScope.$apply()

    expect(Entry.loaded).toBeTruthy()
    expect(Entry.entries.length).toEqual(1)

  it "doesnt load if it has already loaded", inject (Entry, $rootScope) ->
    Entry.loaded = true
    entriesJSON = JSON.stringify [description: "an entry"]
    storage = { getItem: -> entriesJSON }
    sinon.stub(Entry, 'storage').returns(storage)

    expect(Entry.entries).toEqual([])
    Entry.load()
    $rootScope.$apply()

    expect(Entry.entries).toEqual([])

  it "creates a new Entry and pushes it to its collection", inject (Entry) ->
    entry = Entry.createNewEntry description: "an entry"
    expect(Entry.entries[0]).toEqual(entry)

  it "creates a new Entry and does not push it to its collection", inject (Entry) ->
    entry = Entry.createTempEntry description: "an entry"
    expect(Entry.entries).toEqual([])

  it "deletes an entry", inject (Entry, $rootScope) ->
    entry = Entry.createNewEntry description: "an entry"
    expect(Entry.entries[0]).toEqual(entry)

    Entry.deleteEntry(entry)
    $rootScope.$apply()

    expect(Entry.entries).toEqual([])

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
    Entry.currentEntry (currentEntry) ->
      expect(currentEntry).toEqual(entry)
      sinon.assert.calledOnce(Entry.load)
    Entry.load.yield()


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

    it "clears all entries but the current one", inject (Entry, $rootScope) ->
      sinon.stub(Entry, 'save')
      expect(Entry.entries.length).toBe(3)

      Entry.clear()
      $rootScope.$apply()

      expect(Entry.entries.length).toBe(1)
      sinon.assert.calledOnce(Entry.save)






