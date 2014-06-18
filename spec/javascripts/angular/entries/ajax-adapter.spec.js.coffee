describe "AjaxAdapter", ->
  $httpBackend = null

  beforeEach module("entries")

  beforeEach module(($provide) ->
    $provide.value "user",
      token: 1234
    return undefined
  )

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "creating entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("POST", "/entries").respond({ entry: { id: "1", tagList: "whatever" } })

    it "creates entries via ajax", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectPOST('/entries', { entry: { tagList: "whatever"}, token: 1234 })
      entry = { toJSON: (-> { tagList: "whatever"}), assignOnSave: -> }
      sinon.stub(entry, "assignOnSave")

      AjaxAdapter.save(entry).then (entry) ->
        sinon.assert.calledWith(entry.assignOnSave, { id: "1", tagList: "whatever" })

      $httpBackend.flush()
      $rootScope.$apply()

  describe "updating entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("PUT", "/entries/1").respond({ entry: { id: "1", tagList: "an updated tagList" } })

    it "updates entries via ajax", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectPUT('/entries/1', { entry: { id: 1,  tagList: "whatever"}, token: 1234 })
      entry = { id: 1,  toJSON: ( -> { id: 1, tagList: "whatever"}), assignOnSave: -> }
      sinon.stub(entry, "assignOnSave")

      AjaxAdapter.save(entry).then (entry) ->
        sinon.assert.calledWith(entry.assignOnSave, { id: "1", tagList: "an updated tagList" })

      $httpBackend.flush()
      $rootScope.$apply()

  describe "index entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("GET", "/entries?token=#{1234}").respond({ entries: [{ id: "1", tagList: "an updated tagList" }] })

    it "loads all entries", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectGET("/entries?token=#{1234}")

      AjaxAdapter.index().then (entries) ->
        expect(entries.length).toEqual(1)
        expect(entries[0].id).toEqual("1")

      $httpBackend.flush()
      $rootScope.$apply()

  describe "deleting entry", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("DELETE", "/entries/1?token=1234").respond({ success: "true" })

    it "deletes an entry", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectDELETE("/entries/1?token=1234")
      entry = { id: "1", toJSON: -> { tagList: "tagList"} }

      AjaxAdapter.delete(entry)

      $httpBackend.flush()
      $rootScope.$apply()

  describe "clearing all entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("DELETE", "/entries?token=1234&ids%5B%5D=1&ids%5B%5D=2&ids%5B%5D=3").respond({ success: "true" })

    it "clears all entries", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectDELETE("/entries?token=1234&ids%5B%5D=1&ids%5B%5D=2&ids%5B%5D=3")

      AjaxAdapter.clear([{ id: 1 },{ id: 2 },{ id: 3 }])

      $httpBackend.flush()
      $rootScope.$apply()
