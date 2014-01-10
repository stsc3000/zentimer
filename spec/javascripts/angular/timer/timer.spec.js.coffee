describe "Timer", ->

  beforeEach module "timer"

  beforeEach module(($provide) ->
    $provide.value "ZenTimer",
      increment: ->
    return undefined
  )

  it "increments the ZenTimer each second", inject ($timeout, ZenTimer) ->
    sinon.stub ZenTimer, 'increment'
    $timeout.flush()
    sinon.assert.calledOnce(ZenTimer.increment)
