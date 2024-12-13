# 08 Dangle Jam

Demonstrates path following and pin joints.

## Path Following

To have an object move along a path, you must add a `Path2D` node that has a  `PathFollow2D` as its child. Anything that is a child of the `PathFollow2D` node will follow the path.  The movement of the item is controlled by the "Progress" value of the  `PathFollow2D` (in the inspector.)

To automate this, [game.gd](./scripts/game.gd) has a one-line command that updates the progress value each frame: 

```
path_follow.progress += (base_speed * tempo_slider.value )* delta
```

## Pin Joints

Godot comes packaged with a series of "joint" nodes that determine the physical relationship between two colliders. There is `PinJoint2D` (used in this example), `GrooveJoint2D` and `SpringJoint2D`. 

The rope instrument is composed of several PinJoint2D that combine a series of RigidBody2Ds (the bells) and a StaticBody2D (the base).  If you select one of the Pin Joints in [rope.tscn](./scenes/rope.tscn) you can see a `Joint2D` section of the inspector where Node A and Node B can be assigned.

## Make this demo better!

There is some non-intuitive collision logic in the [draggable_instrument](./scripts/draggable_instrument.gd) script. Because each item needs to both be draggable _and_ be a trigger,  there are two colliders nested inside the same `StaticBody2D` node.  One is used for the dragging, while the other interacts with the trigger.  

Please submit a pull request on this demo if you can figure out how to do it with one collider. I would love to know.

## Credits
This demo was created by [Nate Laffan](https://github.com/laffan).