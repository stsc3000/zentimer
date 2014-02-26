describe "AjaxSettingsAdapter", ->
  $httpBackend = null

  beforeEach module("settings")

  beforeEach module(($provide) ->
    $provide.value "user",
      token: 1234
    return undefined
  )

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "updating settings", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("PUT", "/1234.json").respond({ entries: [], tags: ['tag1', 'tag2'], projects: ['projects1', 'projects2'] })
 
    it "updates settings via ajax", inject (AjaxSettingsAdapter, $rootScope) ->
      $httpBackend.expectPUT('/1234.json', { user: { tags: ['tag1', 'tag2'] } })

      tags = ['tag1', 'tag2']

      AjaxSettingsAdapter.save('tags', tags).then (responseTags) ->
        expect(tags).toEqual(responseTags)

      $httpBackend.flush()
      $rootScope.$apply()

  describe "read settings via ajax", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("GET", "/1234.json").respond({ entries: [], tags: ['tag1', 'tag2'], projects: ['projects1', 'projects2'] })

    it "loads all tags", inject (AjaxSettingsAdapter, $rootScope) ->
      $httpBackend.expectGET("/1234.json")

      AjaxSettingsAdapter.fetch("tags").then (tags) ->
        expect(tags.length).toEqual(2)
        expect(tags[0]).toEqual('tag1')
        expect(AjaxSettingsAdapter.settings.tags.length).toEqual(2)
        expect(AjaxSettingsAdapter.settings.projects.length).toEqual(2)

      $httpBackend.flush()
      $rootScope.$apply()
