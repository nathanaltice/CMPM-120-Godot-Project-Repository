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

This demo utilizes two types of particle systems: [CPUParticles2D](https://docs.godotengine.org/en/stable/classes/class_cpuparticles2d.html#class-cpuparticles2d) and [GPUParticles2D](https://docs.godotengine.org/en/stable/classes/class_gpuparticles2d.html#class-gpuparticles2d). Each particle system has strengths and weaknesses, as detailed below:

- CPU Particles
  - These are particles whose behaviors are calculated and controlled by the CPU.
  - These particles are much easier to design and make particle animations.
  - These are good for complex, overly customized particle animations
  - These particles are good at lower quantities and begin to lag games at larger quantities.
  - EX: a sprite sheet particle system such as a butterfly flapping its wings with a trail.
  
- GPU Particles
  - These are particles whose behaviors are calculated and controlled by the GPU.
  - These particles are a little harder to design and animate.
  - These are good for animations where you’ll need a lot of particles
  - EX: Fire in a burning house

 In this demo, the bubble particles in the background are [CPUParticles2Ds](https://docs.godotengine.org/en/stable/classes/class_cpuparticles2d.html#class-cpuparticles2d), and the stars that spawn when the ball hits a bouncy surface are [GPUParticles2Ds](https://docs.godotengine.org/en/stable/classes/class_gpuparticles2d.html#class-gpuparticles2d).

 One interesting thing about the star particle systems that spawn is that they are coded with a garbage collection feature. When a particle system is spawned, it will wait a certain amount of time and then destroy itself. As programmers, we have to delete these spawned objects ourselves. Otherwise, as the game goes on, there will be dozens of inactive particle systems littering our game, causing the game to lag the longer the player plays the game.

