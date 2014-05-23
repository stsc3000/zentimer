describe "ZenTimerCtrl", ->

  $scope = undefined
  $location = undefined
  $rootScope = undefined
  createController = undefined

  beforeEach module("zen-timer")

  beforeEach module(($provide) ->
    $provide.value "ZenTimer",
      init: ->
      done: ->
      toggle: ->
      savable: ->
      deleteCurrent: ->
    return undefined
  )


  beforeEach module(($provide) ->
    $provide.value "Settings",
      tags: ->
        then: ->
      saveTags: ->
        then: ->
      projects: ->
        then: ->
      saveProjects: ->
        then: ->
    return undefined
  )



  beforeEach inject(($injector) ->
    $rootScope = $injector.get("$rootScope")
    $scope = $rootScope.$new()

    $controller = $injector.get("$controller")
    createController = ->
      $controller "ZenTimerCtrl",
        $scope: $scope
  )

  it "should initialize the ZenTimer", inject (ZenTimer) ->
    sinon.stub(ZenTimer, 'init')
    controller = createController()
    sinon.assert.calledOnce(ZenTimer.init)

  it "should set ZenTimer as the timer", inject (ZenTimer) ->
    controller = createController()
    expect($scope.timer).toEqual(ZenTimer)

  it "should done an entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, 'done')
    controller = createController()
    $scope.done()
    sinon.assert.calledOnce(ZenTimer.done)

  it "should toggle an entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, 'toggle')
    controller = createController()
    $scope.toggle()
    sinon.assert.calledOnce(ZenTimer.toggle)

  it "should know when to show a save Button", inject (ZenTimer) ->
    sinon.stub(ZenTimer, 'savable').returns(true)
    controller = createController()
    expect($scope.showDoneButton()).toBeTruthy()

  it "should delete the current entry", inject (ZenTimer) ->
    sinon.stub(ZenTimer, 'deleteCurrent')
    controller = createController()
    $scope.delete()
    sinon.assert.calledOnce(ZenTimer.deleteCurrent)

