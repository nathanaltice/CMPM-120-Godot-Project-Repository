features
the interesting things in this project





# Keeping Tabs Game

This demo was made by Nicholas Nolasco and is a recreation of one of his early games.

Keepings tabs is a unique platformer with procedurally generated levels and movable platforms. The player takes the role of the mouse, trying to run across the screen and stop the a virus from downloading by pressing the "cancel" button.

This Keeping Tabs demo contains the following key designs:

## A Playable Character

The player character in this demo is a [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html). This character can walk, jump, collide with walls, enter triggers, die, and animate. The character can also send out a signal for when it dies.

The character controller in this demo is very simple because the main draw of this game is the moving platforms. As a result, we just need a character that can move and interact with the movable windows death boxes, and winning button.

## Click/Movable Platforms

The moving window is the most complex character in this demo. The movable window is made up of the following:

-A Mouse Drag Area
--This drag area is used to detect if the player wants to drag the border window.
--If the player starts clicking on the window, the window will follow the player's mouse around, only stopping when the player releases the mouse.
--When the player is dragging the window around, this also disables collisions with the player, so the mouse character can't be pushed around or walk across a moving window.

-A Player Trigger Area
--This trigger area detects if the player is inside the window.
--This trigger area prevents the player from clicking on and dragging the window while the mouse character is standing inside of it. This is to prevent the mouse from falling through the world, since dragging a window disables collisions.

-Good And Bad Tiles
--Tiles inside of a draggable window are what the player can stand on or die on. Both good and bad tiles exist on the same script, and are determined by a bool (true or false value).
--If a tile is marked as a good tile, then it only cares about collisions with the player and doesn't kill the player
--If a tile is marked as a bad tile, then it has an [Area2D]() trigger and will kill the player when they walk inside of it
--Both good and bad tiles are the same object so that procedurally generating levels is easier.


## Procedural Generation

## Level Loading
