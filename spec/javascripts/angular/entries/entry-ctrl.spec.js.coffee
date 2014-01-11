describe "EntryCtrl", ->

  $scope = undefined
  $location = undefined
  $rootScope = undefined
  createController = undefined

  beforeEach module("entries")

  beforeEach module(($provide) ->
    $provide.value "ZenTimer",
      delete: ->
      continue: ->
      pause: ->
    return undefined
  )


  beforeEach inject(($injector) ->
    $rootScope = $injector.get("$rootScope")
    $scope = $rootScope.$new()

    $controller = $injector.get("$controller")
    createController = ->
      $controller "EntryCtrl",
        $scope: $scope
  )

  it "deletes the entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "delete")
    controller = createController()
    $scope.entry = {}

    $scope.delete()
    sinon.assert.calledWith(ZenTimer.delete, $scope.entry)

  it "continues the entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "continue")
    controller = createController()
    $scope.entry = {}

    $scope.continue()
    sinon.assert.calledWith(ZenTimer.continue, $scope.entry)

  it "pauses the entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "pause")
    controller = createController()

    $scope.pause()
    sinon.assert.calledOnce(ZenTimer.pause)

  it "pauses the entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "pause")
    controller = createController()

    $scope.pause()
    sinon.assert.calledOnce(ZenTimer.pause)

  it "toggles and pauses the entry if it is running", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "pause")
    controller = createController()
    $scope.entry = { running: true }

    $scope.toggleRunning()
    sinon.assert.calledOnce(ZenTimer.pause)

  it "toggles and continues the entry if it is not running", inject (ZenTimer) ->
    sinon.stub(ZenTimer, "continue")
    controller = createController()
    $scope.entry = { running: false }

    $scope.toggleRunning()
    sinon.assert.calledOnce(ZenTimer.continue)

