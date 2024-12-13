# 02 Bum Bum Bum

This demo contains introductory examples of Audio Bus Effects and Custom Keyboard Input. 


## Audio Bus Effects

The Audio tab has a bus titled "Bum" which includes two effects: Chorus and PitchShift. (View these by opening up the "Audio Bus" tab when the `AudioStreamPlayer2D` is selected.) See [button.gd](scripts/button.gd) to see how we then adjust these effects programmatically, inside the `play_sound()` function. 


## Custom Keyboard Input

Keyboard keys have been added via Project Settings > Input Map. The specific key is then passed in to its respective button via an `@export` variable called `triggerAction` in  [button.gd](scripts/button.gd).

## Credits
This demo was created by [Nate Laffan](https://github.com/laffan).