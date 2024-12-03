# This script is for the paddle. This is the main controllable character by the
# player. This paddle can be on the left or right side of the board. Paddles
# extend CharacterBody2D so we can give players greater control over whether the
# flipper is raised or lowered.

extends CharacterBody2D

# Input map variables
@export var paddle_side: String = "left"

# Rotational states of the paddle variables
var raised_angle: float = 70
var lowered_angle: float = -20
var direction: float = -1 # for rotating up or down, depending on the side of
						  # the board

# Rotating variables
var rotation_speed: float = 15

# SFX variables
var pitch_range = Vector2(0.9, 1.1)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If the paddle isn't on the left side
	if(global_scale != Vector2(1,1)):
		#set the action we're looking to to "right"
		paddle_side = "right"
		direction = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_angle = _get_target_angle()
	_rotate_paddle(delta, target_angle)



# This function gets the angle we want the paddle to rotate towards
func _get_target_angle() -> float:
	# if the player is pressing the associated input keys
	if Input.is_action_pressed(paddle_side) or Input.is_action_pressed("both_left_and_right"):
		# rotate upwards
		return raised_angle * direction
	else:
		# rotate downwards
		return lowered_angle * direction



# This function rotates the paddle towards the desired rotation
func _rotate_paddle(delta: float, target: float) -> void:
	# We use degrees for target because its easier to read, now we need to
	# convert it to radians.
	var radians = deg_to_rad(target)
	
	#rotate the paddle towards the desired rotation
	rotation = lerp(rotation, radians, delta * rotation_speed)



# This is a signal from Area2D. This is for juice when the ball hits the paddle
func _on_area_2d_body_entered(body: Node2D) -> void:
	# only if the ball enters the Area2D. We know it will only be the ball
	# because the ball is the only RigidBody2D in our game.
	if body is RigidBody2D:
		var rand_pitch = randf_range(pitch_range.x, pitch_range.y)
		$AudioStreamPlayer.pitch_scale = rand_pitch
		$AnimationPlayer.play("Bounce")
		$AudioStreamPlayer.play()
