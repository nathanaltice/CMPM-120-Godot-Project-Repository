# This script is for the bouncers that move around the board. These are not
# controlled by the player. Bouncer extends Node2D so we can animate the child
# AnimatabltBody2D left/right.

extends Node2D

# Animation variables
var speed_range = Vector2(0.85, 1.15)

# SFX variables
var pitch_range = Vector2(0.9, 1.1)

# Particle Variables
var star_particles = preload("res://scenes/characters/exploding_stars.tscn")

#var _audio_player = #####


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set the animation to a random speed. This is to make it so multiple
	# bouncers feel random/unique.
	var random_speed = randf_range(speed_range.x, speed_range.y)
	$SwayingAnimationPlayer.set_speed_scale(random_speed)
	
	# set the start time of the animation to a random postion. This is to make
	# it so multiple bouncers aren't moving the same direction
	var length = $SwayingAnimationPlayer.current_animation_length;
	var random_time = randf_range(0, length)
	$SwayingAnimationPlayer.advance(random_time)



# This is a signal from Area2D. This is for juice when the ball hits the bouncer
func _on_area_2d_body_entered(body: Node2D) -> void:
	# only if the ball enters the Area2D. We know it will only be the ball
	# because the ball is the only RigidBody2D in our game.
	if body is RigidBody2D:
		var rand_pitch = randf_range(pitch_range.x, pitch_range.y)
		$AudioStreamPlayer.pitch_scale = rand_pitch
		$AnimatableBody2D/BounceAnimationPlayer.play("Bounce")
		$AudioStreamPlayer.play()
		
		# Create a particle system
		var stars = star_particles.instantiate()
		get_tree().root.add_child(stars)
		stars.spawn_particle_system(position, body.position)
