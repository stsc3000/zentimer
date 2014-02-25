describe "LocalStorageSettingsAdapter", ->
  beforeEach module("settings")

  afterEach ->
    localStorage.clear()

  it "saves all tags to localstorage", inject (LocalStorageSettingsAdapter, $rootScope) ->
    tags = ["tag1", "tag2"]
    LocalStorageSettingsAdapter.save("tags", tags).then (tags) ->
      expect(JSON.parse(localStorage.getItem("tags")).length).toEqual(2)
      expect(JSON.parse(localStorage.getItem("tags"))[0]).toEqual("tag1")
      expect(JSON.parse(localStorage.getItem("tags"))[1]).toEqual("tag2")
    $rootScope.$apply()

  it "loads all tags", inject (LocalStorageSettingsAdapter, $rootScope) ->
    window.localStorage.setItem "tags", JSON.stringify ["tag1", "tag2"]

    LocalStorageSettingsAdapter.index("tags").then (tags) ->
      expect(tags.length).toEqual(2)
      expect(tags[0]).toEqual("tag1")
      expect(tags[1]).toEqual("tag2")

    $rootScope.$apply()


