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
      $httpBackend.when("GET", "/1234.json").respond({entries: '{ "foo": "bar" }'})

    it "gets entries via ajax", inject (AjaxAdapter) ->
      $httpBackend.expectGET('/1234.json')
      callback = sinon.spy()
      AjaxAdapter.getItem "entries", callback
      $httpBackend.flush()
      sinon.assert.calledWith callback, { foo: "bar" }
