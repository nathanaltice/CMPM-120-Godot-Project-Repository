# This script is for the pinball. The pinball is not directly controlled by the
# player, and is instead pushed by the paddles, bouncers, barriers, walls, and
# gravity. The pinball extends RigidBody2DNode2D so that it is completely
# controlled by the physics system, and we don't need to move it ourselves.

extends RigidBody2D

# Scaling variables
@export var can_scale: bool = false
var dist_scales: Vector2 = Vector2(0.1, 1.0)
var scale_params: Vector2 = Vector2(50, 800)

# Gravity variables
@export var gravity_multiplier = 1.5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set the gravity of the ball
	gravity_scale = gravity_multiplier



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_scale:
		_chance_ball_scale()


# This is an optional function that scales the ball (and its collisions) as the
# ball moves up the board.
func _chance_ball_scale() -> void:
	
	# get the size percentage from how high on the board the ball is
	var clamped_pos = clamp(position.y, scale_params.x, scale_params.y)
	var size_percentage = (clamped_pos + scale_params.x) / scale_params.y
	
	#get the new scale of the ball based on how high on the board it is
	var new_scale = dist_scales.x + (dist_scales.y - dist_scales.x) * size_percentage
	var scale_vect = Vector2(new_scale, new_scale)
	
	# set the sprite/collider size of the ball
	$Sprite2D.set_global_scale(scale_vect)
	$CollisionShape2D.set_global_scale(scale_vect)
