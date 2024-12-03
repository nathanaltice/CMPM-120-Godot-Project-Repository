# This script is for the ball teleporter at the top and bottom of the board.
# This script teleports the ball to the opposite side if it leaves the board.
# The ball teleporter extends Node2D so we can easily access its Area2D and
# change the teleport location.

extends Node2D

# SFX variables
var pitch_range = Vector2(0.9, 1.1)


# This is a signal from Area2D. This is for juice when the ball hits the trigger
func _on_area_2d_body_entered(body: Node2D) -> void:
	# only if the ball enters the Area2D. We know it will only be the ball
	# because the ball is the only RigidBody2D in our game.
	if body is RigidBody2D:
		# In order to teleport a RigidBody2D, it must be frozen
		body.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
		
		#debug
		print("Before teleport position: " + str(body.global_position))
		
		# Teleport the ball
		body.global_position = $"Teleport Location".global_position
		
		#debug
		print("After teleport position: " + str(body.global_position))
		
		# Unfreeze the ball so it can move again
		body.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
		
		# Play an SFX for the ball teleporting to the other side of the board
		$AudioStreamPlayer.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
		$AudioStreamPlayer.play()
