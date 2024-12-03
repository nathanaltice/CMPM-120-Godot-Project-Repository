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
  - This drag area is used to detect if the player wants to drag the border window.
  - If the player starts clicking on the window, the window will follow the player's mouse around, only stopping when the player releases the mouse.
  - When the player is dragging the window around, this also disables collisions with the player, so the mouse character can't be pushed around or walk across a moving window.

- A Player Trigger Area
  - This trigger area detects if the player is inside the window.
  - This trigger area prevents the player from clicking on and dragging the window while the mouse character is standing inside of it. This is to prevent the mouse from falling through the world, since dragging a window disables collisions.

- Good And Bad Tiles
  - Tiles inside of a draggable window are what the player can stand on or die on. Both good and bad tiles exist on the same script and are determined by a bool (true or false value).
  - If a tile is marked as a good tile, then it only cares about collisions with the player and doesn't kill the player
  - If a tile is marked as a bad tile, then it has an [Area2D]() trigger and will kill the player when they walk inside it
  - Both good and bad tiles are the same object, so procedurally generating levels is easier on the programmer.

## Procedural Generation

This game procedurally generates all of its computer window platforms at the start of a level. It does this by getting a random [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) from a random [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) of integer [Arrays](https://docs.godotengine.org/en/stable/classes/class_array.html) and using those integers to procedurally create a level. You can think of an [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) of [Arrays](https://docs.godotengine.org/en/stable/classes/class_array.html) as a book with all its pages filled with words, where we're going to a random page and then read all the words off of that page.

Using the random array we get, we can spawn certain tiles in a certain position inside of a window. For example, we can spawn a row of bad tiles underneath a row of good tiles in a window. By making each level random, it adds more replay value to the game.

One thing to note about the random array we get is that it looks like this in [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html):


## Level Loading
