angular.module("app").
  service("Audio", () ->
    {
      sounds:{} 
      register: (name, el) ->
        @sounds[name] = el
      play: (name) ->
        @sounds[name].play()
    }
  )
