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

  describe "setting entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("PUT", "/1234").respond({status: "success"})

    it "sets entries via ajax", inject (AjaxAdapter) ->
      $httpBackend.expectPUT('/1234', { foo: "bar" })
      callback = sinon.spy()
      AjaxAdapter.setItem "foo", "bar", callback
      $httpBackend.flush()
      sinon.assert.calledWith callback, { status: "success" }

  describe "getting entries", ->
    beforeEach inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when("GET", "/1234").respond({entries: []})

    it "gets entries via ajax", inject (AjaxAdapter) ->
      $httpBackend.expectGET('/1234')
      callback = sinon.spy()
      AjaxAdapter.getItem "entries", callback
      $httpBackend.flush()
      sinon.assert.calledWith callback, []




  #it "reads entries from localstorage", inject (LocalStorageAdapter) ->
    #localStorage.setItem("foo", "bar")
    #LocalStorageAdapter.getItem "foo", (foo) ->
      #expect(foo).toEqual("bar")

