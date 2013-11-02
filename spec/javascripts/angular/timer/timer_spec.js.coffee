describe "timerService", ->

  beforeEach module("timer")

  TimerService = null

  beforeEach inject (_TimerService_) ->
    TimerService = _TimerService_

  it "has default values", ->
    expect(TimerService.currentEntry).toBeFalsy()
    expect(TimerService.running).toBeFalsy()

  it "can start and pause", ->
    TimerService.start()
    expect(TimerService.running).toBeTruthy()
    TimerService.pause()
    expect(TimerService.running).toBeFalsy()

  it "can set an entry", ->
    someEntry = { whatever: "idunno" }
    TimerService.setEntry(someEntry)
    expect(TimerService.currentEntry).toBe(someEntry)

  it "does not increment the entry if it is not running", ->
    inject ($timeout) ->
      someEntry = { whatever: "idunno", increment: -> }
      sinon.stub(someEntry, "increment")
      TimerService.setEntry(someEntry)
      $timeout.flush()
      sinon.assert.notCalled(someEntry.increment)

  it "increments the entry if it is running", ->
    inject ($timeout) ->
      someEntry = { whatever: "idunno", increment: -> }
      sinon.stub(someEntry, "increment")
      TimerService.setEntry(someEntry)
      TimerService.start()
      $timeout.flush()
      sinon.assert.calledOnce(someEntry.increment)

