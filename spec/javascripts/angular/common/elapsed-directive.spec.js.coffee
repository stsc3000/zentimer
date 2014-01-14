describe "tiElapsed", ->
  elm = undefined
  scope = undefined

  beforeEach module "app"

  beforeEach inject ($rootScope, $compile) ->
    elm = angular.element ('
      <div>
        <ti-elapsed elapsed="timer.currentEntry.elapsed" > </ti-elapsed>
      </div>
    ')

    scope = $rootScope
    $compile(elm)(scope)
    scope.$digest()

  it "should show the elapsed duration", ->
    timer = 
      currentEntry:
        elapsed: ( 3600 + 60 + 30 )

    scope.timer = timer
    scope.$digest()

    text = $(elm).text().replace(///\s///g, "")
    expect(text).toEqual("01:01:30")
