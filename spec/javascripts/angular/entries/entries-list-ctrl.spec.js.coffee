describe "EntriesListCtrl", ->

  $scope = undefined
  $location = undefined
  $rootScope = undefined
  createController = undefined

  beforeEach module("entries")
  beforeEach module("app")

  beforeEach module(($provide) ->
    $provide.value "ZenTimer",
      entries: []
      totalElapsed: ->
      addEntry: ->
      init: ->
      clear: ->
    return undefined
  )


  beforeEach inject(($injector) ->
    $rootScope = $injector.get("$rootScope")
    $scope = $rootScope.$new()

    $controller = $injector.get("$controller")
    createController = ->
      $controller "EntriesListCtrl",
        $scope: $scope
  )

  it "uses the ZenTimer entries", inject (ZenTimer) ->
    controller = createController()
    expect($scope.entries).toEqual(ZenTimer.entries)

  it "adds an Entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "addEntry")
    controller = createController()
    $scope.addEntry()
    sinon.assert.calledOnce(ZenTimer.addEntry)


  it "calculates the entries sum", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "totalElapsed").returns(10)
    controller = createController()
    total = $scope.totalElapsed()
    sinon.assert.calledOnce(ZenTimer.totalElapsed)
    expect(total).toBe(10)

  describe "clearing entries", ->
    beforeEach inject (ZenTimer) ->
      sinon.stub(ZenTimer, "clear")
      sinon.restore(window.confirm)
      sinon.stub(window, 'confirm')

    it "clears all entries if confirmed", inject (ZenTimer) ->
      window.confirm.returns(true)
      controller = createController()
      $scope.clear()
      sinon.assert.calledOnce(ZenTimer.clear)

    it "keeps all entries if not confirmed", inject (ZenTimer) ->
      window.confirm.returns(false)
      controller = createController()
      $scope.clear()
      sinon.assert.notCalled(ZenTimer.clear)

  it "knows when an entry has run once", ->
    entryThatHasNotRun = 
      hasRunOnce: -> false
    entryThatHasRun = 
      hasRunOnce: -> true

    controller = createController()
    expect($scope.hasRunOnce(entryThatHasNotRun)).toBeFalsy()
    expect($scope.hasRunOnce(entryThatHasRun)).toBeTruthy()
