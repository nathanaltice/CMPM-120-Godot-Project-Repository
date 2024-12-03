# Pinball Phhysics Demo

This demo was made by Nicholas Nolasco.

This demo is a pinball game designed to show the different types of physics bodies and systems in Godot. The player takes control of two paddles and can hit the ball around the pinball arena.

### This pinball demo contains the following key designs:

## Different Godot Physics Bodies

This demo uses all of Godots physics bodies: [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html), [AnimatedBody2D](https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html), and [StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d) as well as Godot's [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d). The characters in this game use the following physics bodies:

- The Paddles
  - Paddles in this game use Godot's [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html).
  - Paddles use [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html) so players can have very specific control over the bumpers’ rotations
    - Ex: being able to hold the paddle in the up direction

- The Bouncers
  - Bouncers in this game use Godot's [AnimatedBody2D](https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html)
  - Bouncers use [AnimatedBody2D](https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html) because we want the bouncers to slowly animate around the board, pushing the pinball but never being moved by another object

- Bumpers
  - Bumpers in this game use Godot's [StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d)
  - Bumpers use [StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d) because we want the bumpers not to move, only to be a surface the pinball can bounce off of
 
- The Walls
  - Walls in this game use Godot's [StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d)
  - Walls use [StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d) because we want the Walls not to move, only to be a surface the pinball can bounce off of

- The Pinball
  - The pinball in this game use Godot's [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d)
  - The pinball uses a [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d) we want the pinball to be completely driven by the physics system; we don’t want players to control the pinball directly


## Godot Physics Materials

When two physics objects interact in Godot, their interaction behavior can be altered using Godot's [physics materials](https://docs.godotengine.org/en/stable/classes/class_physicsmaterial.html). A physics material changes how one object bounces off another and how much each material will slow the other down. In a game like this pinball demo, changing how physics bodies interact with each other can make the game more interesting and engaging.

In this demo, each object has the following effects from a physics material:

- Paddles:
  - Slightly bounce the pinball

- Pinball:
  - Bounce off of every surface

- Bumpers:
  - Inner wall: Bounce the pinball a lot
  - Outer wall: Don’t bounce the pinball

- Bouncers:
  - Bounce the pinball a lot

- Walls:
  - Don’t bounce the pinball




## Particle Systems

