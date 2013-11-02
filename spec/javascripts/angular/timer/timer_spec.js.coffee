describe "timerService", ->

  $q = null
  TimerService = null

  beforeEach module("timer", ($provide) ->
    mockEntryService = ->
      increment: ->
      start: ->
      pause: ->
    $provide.value('Entry', mockEntryService)
    return false
  )


  beforeEach inject (_TimerService_, _$q_) ->
    TimerService = _TimerService_
    $q = _$q_

  it "has default values", ->
    expect(TimerService.currentEntry).toBeTruthy()

  it "can start an entry", ->
    sinon.stub(TimerService.currentEntry, "start")
    TimerService.start()
    sinon.assert.calledOnce(TimerService.currentEntry.start)

  it "can pause an entry", ->
    sinon.stub(TimerService.currentEntry, "pause")
    TimerService.pause()
    sinon.assert.calledOnce(TimerService.currentEntry.pause)

  it "can set an entry", ->
    someEntry = { whatever: "idunno" }
    TimerService.setEntry(someEntry)
    expect(TimerService.currentEntry).toBe(someEntry)

  it "does not increment the entry if it is not running", ->
    inject ($timeout) ->
      sinon.stub(TimerService.currentEntry, "increment")
      TimerService.runLoop()
      $timeout.flush()
      sinon.assert.notCalled(TimerService.currentEntry.increment)

  it "increments the entry if it is running", ->
    inject ($timeout) ->
      sinon.stub(TimerService.currentEntry, "increment")
      TimerService.currentEntry.running = true
      TimerService.start()
      TimerService.runLoop()
      $timeout.flush()
      sinon.assert.calledOnce(TimerService.currentEntry.increment)

