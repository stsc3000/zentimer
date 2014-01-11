describe "Entry", ->
  beforeEach module("app")

  Entry = null

  beforeEach inject (_Entry_) ->
    Entry = _Entry_

  it "has default instance values", ->
    entry = new Entry
    expect(entry.elapsed).toBe(0)
    expect(entry.description).toBe("")

  it "increments its elapsed value", ->
    entry = new Entry
    entry.increment()
    expect(entry.elapsed).toBe(1)

  it "knows when it has run", ->
    entry = new Entry
    expect(entry.hasRunOnce()).toBeFalsy()
    entry.elapsed = 1
    expect(entry.hasRunOnce()).toBeTruthy()
