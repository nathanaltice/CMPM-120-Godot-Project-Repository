extends Area2D


var window_size : Vector2			# stores window size
var barrier_size : Vector2			# stores barrier size
var barrier_speed : int				# stores barrier speed
var spawn_lock := false				# tracks whether to spawn new barrier
var explosion_scene : PackedScene

@onready var barrier_rectangle = $ColorRect

func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	barrier_size = barrier_rectangle.get_size()
	
	# preload explosion particles
	explosion_scene = preload("res://scenes/paddle_explosion.tscn")


func _process(delta: float) -> void:
	# move the barrier left
	position.x -= barrier_speed * delta
	
	# when current barrier hits mid-screen, recursively spawn next barrier
	if position.x < window_size.x / 2 and spawn_lock == false:
		spawn_lock = true
		get_parent().call_deferred("spawn_barrier")
	
	# check for left edge exit
	if position.x < -barrier_size.x:
		Signalbus.barrier_dodged.emit()
		queue_free()


func initialize_barrier(speed):
	# set speed
	barrier_speed = speed
	# set x and (random) y-position
	position.x = window_size.x
	position.y = randf_range(24, window_size.y - barrier_size.y - 24)
	# randomize color
	var rand_color = Color(randf(), randf(), randf(), 1)
	barrier_rectangle.color = rand_color


# handle collision
func _on_body_entered(body: Node2D) -> void:
	Signalbus.player_death.emit()
	remove()


func remove() -> void:
	# instance particle explosion and set to paddle position
	var explosion = explosion_scene.instantiate()
	get_parent().add_child(explosion)
	explosion.position = position
	explosion.position.y += barrier_size.y / 2
	explosion.emitting = true
	explosion.one_shot = true
	explosion.color = $ColorRect.color
	# release node
	queue_free()
