# Keeping Tabs Game

This demo was made by Nicholas Nolasco and is a recreation of one of his early games.

Keeping tabs is a unique platformer with procedurally generated levels and movable platforms. The player takes the role of the mouse, trying to run across the screen and stop a virus from downloading by pressing the "cancel" button.

### This Keeping Tabs demo contains the following key designs:

## A Playable Character

The player character in this demo is a [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html). This character can walk, jump, collide with walls, enter triggers, die, and animate. The character can also send out a signal for when it dies.

The character controller in this demo is very simple because the main draw of this game is the moving platforms. As a result, we just need a character that can move and interact with the movable windows death boxes, and winning button.

## Click/Movable Platforms

The moving window is the most complex character in this demo. The movable window is made up of the following:

- A Mouse Drag Area
  - This drag area detects if the player wants to drag the border window.
  - If the player's mouse enters the associated [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html) and starts clicking on the window, the window will follow the player's mouse around, only stopping when the player releases the mouse.
  - When the player is dragging the window around, this also disables collisions with the player, so the mouse character can't be pushed around or walk across a moving window.

- A Player Trigger Area
  - This trigger area detects if the player is inside the window.
  - This trigger area prevents the player from clicking on and dragging the window while the mouse character stands inside its associated [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html). This prevents the mouse from falling through the world since dragging a window disables collisions.

- Good And Bad Tiles
  - Tiles inside of a draggable window are what the player can stand on or die on. Both good and bad tiles exist on the same script and are determined by a bool (true or false value).
  - If a tile is marked as a good tile, then it only cares about collisions with the player and doesn't kill the player
  - If a tile is marked as a bad tile, then it has an [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html) trigger and will kill the player when they walk inside it
  - Both good and bad tiles are the same object, so procedurally generating levels is easier on the programmer.

## Procedural Generation

This game procedurally generates all of its computer window platforms at the start of a level in the [WindowDrag.gd](Scripts/WindowDrag.gd) script. It does this by getting a random [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) from a random [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) of integer [Arrays](https://docs.godotengine.org/en/stable/classes/class_array.html) and using those integers to procedurally create a level. You can think of an [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) of [Arrays](https://docs.godotengine.org/en/stable/classes/class_array.html) as a book with all its pages filled with words, where we're going to a random page and then read all the words off of that page.

Using the random array we get, we can spawn certain tiles in a certain position inside of a window. For example, we can spawn a row of bad tiles underneath a row of good tiles in a window. By making each level random, it adds more replay value to the game.


One thing to note about the random array we get is that it looks like this in [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html):
```
const TILE_PATTERNS =  [[0,0,0,0,0,
                         0,0,0,0,0,
                         0,0,0,0,0,
                         1,1,1,1,1],
                        ...
```
This is just a single [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) of numbers separated by new lines, giving the illusion that each line is its own [Array](https://docs.godotengine.org/en/stable/classes/class_array.html). In reality, [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) sees this array as:
```
const TILE_PATTERNS =  [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1], ...
```
If you look at the code where tiles are generated in the [WindowDrag.gd](Scripts/WindowDrag.gd) script, you will see that we use the variables `TILE_COLUMNS` and `TILE_ROWS` in the `func spawn_tiles()` to get the "row" and "column of a tile from the random array.

## Level Loading

This game uses two ways of loading new levels: using the [preload()](https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-preload) method to load a scene and using the [ResourceLoader.load_threaded_request()](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html#class-resourceloader-method-load-threaded-request) method. The two loading styles are as follows:

- [preload()](https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-preload)
  - using the [preload()](https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-preload) method allows a scene to be loaded in one frame from a constant file path.
  - This method is for loading scenes quickly. This is good for loading small scenes, such as explosion effects or enemies, but not good for loading whole levels.
  - However, for very small projects, such as this one, this will work for loading-level scenes.

- [ResourceLoader.load_threaded_request()](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html#class-resourceloader-method-load-threaded-request)
  - using the [ResourceLoader.load_threaded_request()](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html#class-resourceloader-method-load-threaded-request) method allows for a scene to be loaded over multiple frames and using multiple threads.
  - This method is for loading large scenes over a long period of time. This is good for loading new levels or cutscenes.
  - For this project, our main scene is small and loads very quickly. However, it's a good demonstration for how you might load a level in a bigger game.

