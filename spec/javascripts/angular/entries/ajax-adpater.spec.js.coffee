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

