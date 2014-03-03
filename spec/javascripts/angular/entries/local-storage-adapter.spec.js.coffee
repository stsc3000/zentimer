describe "LocalStorageAdapter", ->
  beforeEach module("entries")

  afterEach ->
    localStorage.clear()

  it "saves a new entry to localstorage", inject (LocalStorageAdapter, $rootScope) ->
    entry = { toJSON: -> { tag_list: "whatever"} }
    a = LocalStorageAdapter.save(entry).then (entry) ->
      expect(JSON.parse(localStorage.getItem("entries")).length).toEqual(1)
      expect(JSON.parse(localStorage.getItem("entries"))[0].tag_list).toEqual("whatever")
    $rootScope.$apply()

  it "creates a new id if the entry has none", inject (LocalStorageAdapter, $rootScope) ->
    entry = { toJSON: -> { tag_list: "whatever"} }
    expect(entry.id).toBeFalsy()
    LocalStorageAdapter.save(entry).then (entry) ->
      expect(entry.id).toBeTruthy()
    $rootScope.$apply()

  it "updates an entry", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", tag_list: "whatever" }, { id: "13", tag_list: "some other entry" }
    ]

    entry = { id: "12", toJSON: -> { tag_list: "new tag_list"} }

    LocalStorageAdapter.save(entry).then (entry) ->
      entries = JSON.parse window.localStorage.getItem("entries")
      expect(entries.length).toEqual(2)
      expect(entries[0].tag_list).toEqual("new tag_list")
      expect(entries[0].id).toEqual('12')

    $rootScope.$apply()


  it "loads all entries", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", tag_list: "whatever" }, { id: "13", tag_list: "some other entry" }
    ]

    LocalStorageAdapter.index().then (entries) ->
      expect(entries.length).toEqual(2)
      expect(entries[0].id).toEqual("12")

    $rootScope.$apply()

  it "deletes an entry", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", tag_list: "whatever" }, { id: "13", tag_list: "some other entry" }
    ]

    entry = { id: "12", toJSON: -> { tag_list: "new tag_list"} }

    LocalStorageAdapter.delete(entry).then (entries) ->
      expect(entries.length).toEqual(1)
      expect(entries[0].id).toEqual("13")

    $rootScope.$apply()

  it "clears all entries", inject (LocalStorageAdapter, $rootScope) ->
    window.localStorage.setItem "entries", JSON.stringify [
      { id: "12", tag_list: "whatever" }, { id: "13", tag_list: "some other entry" }
    ]

    LocalStorageAdapter.clear().then (entries) ->
      expect(entries.length).toEqual(0)

    $rootScope.$apply()

