# This script is for the barriers that block the pinball. These are not
# controlled by the player. The barrier extends Node2D so we can have multiple
# collision types easily accessible

extends Node2D

# Particle Variables
var star_particles = preload("res://scenes/characters/exploding_stars.tscn")

# SFX variables
var pitch_range = Vector2(0.9, 1.1)

# This is a signal from Area2D. This is for juice when the ball hits the barrier
func _on_area_2d_body_entered(body: Node2D) -> void:
	# only if the ball enters the Area2D. We know it will only be the ball
	# because the ball is the only RigidBody2D in our game.
	if body is RigidBody2D:
		var rand_pitch = randf_range(pitch_range.x, pitch_range.y)
		$AudioStreamPlayer.pitch_scale = rand_pitch
		$AnimationPlayer.play("Bounce")
		$AudioStreamPlayer.play()
		
		# Create a particle system
		var stars = star_particles.instantiate()
		get_tree().root.add_child(stars)
		stars.spawn_particle_system(position, body.position)
