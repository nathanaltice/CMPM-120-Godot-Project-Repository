extends Node2D

@onready var ne: Sprite2D = $NE
@onready var nw: Sprite2D = $NW
@onready var se: Sprite2D = $SE
@onready var sw: Sprite2D = $SW
var topSpeed = 1.0

# To keep things visually interesting, we'd like to randomly 
# assign each mask's rotation speed, so here we are creating 
# a dictionary to hold those values.
var rotation_speeds: Dictionary = {}

func _ready() -> void:
	# Begin by assigning random values (within the topSpeed limit)
	rotation_speeds[ne] = randf_range(-topSpeed, topSpeed)
	rotation_speeds[nw] = randf_range(-topSpeed, topSpeed)
	rotation_speeds[se] = randf_range(-topSpeed, topSpeed)
	rotation_speeds[sw] = randf_range(-topSpeed, topSpeed)


func _process(delta: float) -> void:
	# Update the rotation of each sprite
	for sprite in rotation_speeds.keys():
		sprite.rotation += rotation_speeds[sprite] * delta
