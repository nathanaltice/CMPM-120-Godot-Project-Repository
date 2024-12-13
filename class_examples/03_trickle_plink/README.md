# 03 Trickle Plink

This demo contains an example of how to create and detect physics collisions with certain tiles as well as a basic method of creating overlapping audio players.

## Tilemap Collisions & Custom Data Layers

Using the custom data layers function, certain tiles have been assigned "color" string  (in the inspector click on the tileset, then Custom Data Layer) that has been added as an attribute. 

When the ball collides with a tile that has this property, `local_to()` and `local_to_map()` are used to determine which tile has been hit, so the correct sound can be triggered.  See `_on_body_entered()` in the [ball.gd](scripts/ball.gd).


## Overlapping Audio Players

Because the bell audio needs to overlap (and a single AudioStream would cut itself off with each successive sound) in the `_ready()` of [ball.gd](scripts/ball.gd) several audio players are generated. Inside the `play_sound()` function the new sound is assigned to and played from the current audio player. Then and a new current player is assigned using modulo to keep within the bounds of the player array.

## Bonus 🎁

Go generate your own geometric tilemap tiles at [The Simplest Tileset Generator](https://laffan.github.io/simple-tileset-generator/)

## Credits
This demo was created by [Nate Laffan](https://github.com/laffan).