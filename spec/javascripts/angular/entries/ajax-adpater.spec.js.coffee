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
      $httpBackend.when("POST", "/entries").respond({ entry: { id: "1", description: "whatever" } })

    it "creates entries via ajax", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectPOST('/entries', { entry: { description: "whatever"}, token: 1234 })
      entry = { toJSON: (-> { description: "whatever"}), assign: -> }
      sinon.stub(entry, "assign")

      AjaxAdapter.save(entry).then (entry) ->
        sinon.assert.calledWith(entry.assign, { id: "1", description: "whatever" })

      $httpBackend.flush()
      $rootScope.$apply()

  describe "updating entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("PUT", "/entries/1").respond({ entry: { id: "1", description: "an updated description" } })

    it "updates entries via ajax", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectPUT('/entries/1', { entry: { id: 1,  description: "whatever"}, token: 1234 })
      entry = { id: 1,  toJSON: ( -> { id: 1, description: "whatever"}), assign: -> }
      sinon.stub(entry, "assign")

      AjaxAdapter.save(entry).then (entry) ->
        sinon.assert.calledWith(entry.assign, { id: "1", description: "an updated description" })

      $httpBackend.flush()
      $rootScope.$apply()

  describe "index entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("GET", "/entries?token=#{1234}").respond({ entries: [{ id: "1", description: "an updated description" }] })

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
      entry = { id: "1", toJSON: -> { description: "description"} }

      AjaxAdapter.delete(entry)

      $httpBackend.flush()
      $rootScope.$apply()

  describe "clearing all entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("DELETE", "/entries?token=1234").respond({ success: "true" })

    it "clears all entries", inject (AjaxAdapter, $rootScope) ->
      $httpBackend.expectDELETE("/entries?token=1234")

      AjaxAdapter.clear()

      $httpBackend.flush()
      $rootScope.$apply()
