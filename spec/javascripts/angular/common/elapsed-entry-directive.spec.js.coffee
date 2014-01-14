describe "tiElapsed", ->
  elm = undefined
  scope = undefined
  elmBuilder = undefined
  elmScope = undefined

  beforeEach module "app"

  beforeEach inject ($rootScope, $compile) ->
    elmBuilder = (entry) ->
      html = '
        <div>
          <ti-elapsed-entry model="entry" elapsed="entry.elapsed" disabled="entry.running" ></ti-elapsed-entry>
        </div>
      '

      scope = $rootScope
      scope.entry = entry
      elm = $compile(html)(scope)
      elmScope = elm.scope()
      scope.$digest()
      elmScope.$digest()
      $(elm)

  xit "should attach methods to the scope", inject (Entry) ->
    entry = new Entry running: false
    elm = elmBuilder(entry)
    expect(elm.scope().save).toBeDefined()

  it "is disabled if the entry is running", inject (Entry) ->
    entry = new Entry running: true
    elm = elmBuilder(entry)
    expect(elm.find("input").is(":disabled")).toBeTruthy()

  it "is not disabled if the entry is not running", inject (Entry) ->
    entry = new Entry running: false
    elm = elmBuilder(entry)
    expect(elm.find("input").is(":disabled")).toBeFalsy()

  it "shows the elapsed duration", inject (Entry) ->
    entry = new Entry elapsed: (3600 + 60 + 30)
    elm = elmBuilder(entry)
    expect(elm.find("input").val()).toEqual("01:01:30")

  xit "changes the elapsed value of the entry", inject (Entry) ->
    entry = new Entry running: false
    elm = angular.element(elmBuilder(entry))

    elm.find("input").val("01:01:30")
    angular.element(elm).find("input[type=submit]").click()
    expect(entry.elapsed).toEqual(3600 + 60 + 30)
