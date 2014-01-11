describe "ZenTimerCtrl", ->

  $scope = undefined
  $location = undefined
  $rootScope = undefined
  createController = undefined

  beforeEach module("zen-timer")

  beforeEach module(($provide) ->
    $provide.value "ZenTimer",
      entries: []
      addEntry: ->
      init: ->
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

  it "knows when an entry has run once", ->
    entryThatHasNotRun = 
      hasRunOnce: -> false
    entryThatHasRun = 
      hasRunOnce: -> true

    controller = createController()
    expect($scope.hasRunOnce(entryThatHasNotRun)).toBeFalsy()
    expect($scope.hasRunOnce(entryThatHasRun)).toBeTruthy()
