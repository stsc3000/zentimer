describe "LocalStorageTagsAdapter", ->
  beforeEach module("tags")

  afterEach ->
    localStorage.clear()

  it "saves all tags to localstorage", inject (LocalStorageTagsAdapter, $rootScope) ->
    tags = ["tag1", "tag2"]
    LocalStorageTagsAdapter.save(tags).then (tags) ->
      expect(JSON.parse(localStorage.getItem("tags")).length).toEqual(2)
      expect(JSON.parse(localStorage.getItem("tags"))[0]).toEqual("tag1")
      expect(JSON.parse(localStorage.getItem("tags"))[1]).toEqual("tag2")
    $rootScope.$apply()

  it "loads all tags", inject (LocalStorageTagsAdapter, $rootScope) ->
    window.localStorage.setItem "tags", JSON.stringify ["tag1", "tag2"]

    LocalStorageTagsAdapter.index().then (tags) ->
      expect(tags.length).toEqual(2)
      expect(tags[0]).toEqual("tag1")
      expect(tags[1]).toEqual("tag2")

    $rootScope.$apply()


