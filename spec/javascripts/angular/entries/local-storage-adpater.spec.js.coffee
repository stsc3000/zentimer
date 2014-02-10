describe "LocalStorageAdapter", ->
  beforeEach module("entries")

  afterEach ->
    localStorage.clear()

  it "sets entries in localstorage", inject (LocalStorageAdapter) ->
    LocalStorageAdapter.setItem("foo", "bar")
    expect(localStorage.getItem("foo")).toEqual("bar")

  it "reads entries from localstorage", inject (LocalStorageAdapter) ->
    localStorage.setItem("foo", '{ "bar": true }')
    LocalStorageAdapter.getItem "foo", (foo) ->
      expect(foo).toEqual({ bar: true })

