class_name Shape
extends Node

@onready var circle: RigidBody2D = $Circle
@onready var square: RigidBody2D = $Square
@onready var triangle: RigidBody2D = $Triangle

@onready var pop_sound: AudioStreamPlayer2D = $PopSound

var shape_options: Array
var bounciness: float = 0
var selectedOption: RigidBody2D

func _ready():
	# Play the pop sound
	pop_sound.play()
	# Save available shapes to an array
	shape_options = [circle, square, triangle]
	# set default shape (for debugging)
	selectedOption = shape_options[0]  

func init(pos: Vector2, bounce: float, selected_shape: float):
		
	# Remove the options not used.
	for i in range(shape_options.size()):
		if i == selected_shape:
			selectedOption = shape_options[i]
		else:
			shape_options[i].queue_free()
	
	# Set the position of the selected shape	
	selectedOption.position = pos

	# Create a new physics material and apply it to new shape
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = bounce
	selectedOption.physics_material_override = physics_material
