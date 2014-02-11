describe "LocalStorageAdapter", ->
  beforeEach module("entries")

  afterEach ->
    localStorage.clear()

  it "saves a new entry to localstorage", inject (LocalStorageAdapter, $rootScope) ->
    entry = { toJSON: -> { description: "whatever"} }
    a = LocalStorageAdapter.save(entry).then (entry) ->
      expect(JSON.parse(localStorage.getItem("entries")).length).toEqual(1)
      expect(JSON.parse(localStorage.getItem("entries"))[0].description).toEqual("whatever")
    $rootScope.$apply()

  it "creates a new id if the entry has none", inject (LocalStorageAdapter, $rootScope) ->
    entry = { toJSON: -> { description: "whatever"} }
    expect(entry.id).toBeFalsy()
    LocalStorageAdapter.save(entry).then (entry) ->
      expect(entry.id).toBeTruthy()
    $rootScope.$apply()

  it "updates an entry", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", description: "whatever" }, { id: "13", description: "some other entry" }
    ]

    entry = { id: "12", toJSON: -> { description: "new description"} }

    LocalStorageAdapter.save(entry).then (entry) ->
      entries = JSON.parse window.localStorage.getItem("entries")
      expect(entries.length).toEqual(2)
      expect(entries[0].description).toEqual("new description")
      expect(entries[0].id).toEqual('12')

    $rootScope.$apply()


  it "loads all entries", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", description: "whatever" }, { id: "13", description: "some other entry" }
    ]

    LocalStorageAdapter.index().then (entries) ->
      expect(entries.length).toEqual(2)
      expect(entries[0].id).toEqual(12)

  it "deletes an entry", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", description: "whatever" }, { id: "13", description: "some other entry" }
    ]

    entry = { id: "12", toJSON: -> { description: "new description"} }

    LocalStorageAdapter.delete(entry).then (entries) ->
      expect(entries.length).toEqual(1)
      expect(entries[0].id).toEqual("13")

  #it "sets entries in localstorage", inject (LocalStorageAdapter) ->
    #LocalStorageAdapter.setItem("foo", "bar")
    #expect(localStorage.getItem("foo")).toEqual("bar")

  #it "reads entries from localstorage", inject (LocalStorageAdapter) ->
    #localStorage.setItem("foo", '{ "bar": true }')
    #LocalStorageAdapter.getItem "foo", (foo) ->
      #expect(foo).toEqual({ bar: true })

