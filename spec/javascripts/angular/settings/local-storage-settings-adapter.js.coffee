describe "LocalStorageSettingsAdapter", ->
  beforeEach module("settings")

  afterEach ->
    localStorage.clear()

  it "saves all tags to localstorage", inject (LocalStorageSettingsAdapter, $rootScope) ->
    tags = ["tag1", "tag2"]
    LocalStorageSettingsAdapter.save("tags", tags).then (tags) ->
      tags = JSON.parse(localStorage.getItem("settings")).tags
      expect(tags.length).toEqual(2)
      expect(tags[0]).toEqual("tag1")
      expect(tags[1]).toEqual("tag2")
    $rootScope.$apply()

  it "loads all tags", inject (LocalStorageSettingsAdapter, $rootScope) ->
    window.localStorage.setItem "settings", JSON.stringify { tags: ["tag1", "tag2"] }

    LocalStorageSettingsAdapter.fetch("tags").then (tags) ->
      expect(tags.length).toEqual(2)
      expect(tags[0]).toEqual("tag1")
      expect(tags[1]).toEqual("tag2")

    $rootScope.$apply()


  it "saves all projects to localstorage", inject (LocalStorageSettingsAdapter, $rootScope) ->
    projects = ["project1", "project2"]
    LocalStorageSettingsAdapter.save("projects", projects).then (projects) ->
      projects = JSON.parse(localStorage.getItem("settings")).projects
      expect(projects.length).toEqual(2)
      expect(projects[0]).toEqual("project1")
      expect(projects[1]).toEqual("project2")
    $rootScope.$apply()

  it "loads all projects", inject (LocalStorageSettingsAdapter, $rootScope) ->
    window.localStorage.setItem "settings", JSON.stringify { projects: ["project1", "project2"] }

    LocalStorageSettingsAdapter.fetch("projects").then (projects) ->
      expect(projects.length).toEqual(2)
      expect(projects[0]).toEqual("project1")
      expect(projects[1]).toEqual("project2")

    $rootScope.$apply()


