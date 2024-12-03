extends GPUParticles2D

const LIFE_TIME_MULTIPLIER: float = 1.1
const DISTANCE_PERCENTAGE: float = 0.80


func spawn_particle_system(spawn: Vector2, ball: Vector2) -> void:
	# Place the particle system in the world
	var distance_between_points = ball - spawn
	position = spawn + (distance_between_points * DISTANCE_PERCENTAGE)
	look_at(ball)
	
	# Start emiting Particles
	emitting = true
	
	# Find out how long to keep this particle system alive
	var longest_particle_life = lifetime * LIFE_TIME_MULTIPLIER
	_wait_to_die(longest_particle_life)



func _wait_to_die(time_to_die: float) -> void:
	await get_tree().create_timer(time_to_die).timeout
	print("destroying " + name)
	queue_free()
