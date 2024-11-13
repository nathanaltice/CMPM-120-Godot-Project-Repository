extends Area2D


var window_size : Vector2			# stores window size
var barrier_size : Vector2			# stores barrier size
var barrier_speed : int				# stores barrier speed
var spawn_lock := false				# tracks whether to spawn new barrier


func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	barrier_size = $ColorRect.get_size()


func _process(delta: float) -> void:
	# move the barrier left
	position.x -= barrier_speed * delta
	
	# when current barrier hits mid-screen, recursively spawn next barrier
	if position.x < window_size.x / 2 and spawn_lock == false:
		spawn_lock = true
		get_parent().call_deferred("spawn_barrier")
	
	# check for left edge exit
	if position.x < -barrier_size.x:
		queue_free()


func initialize_barrier(speed):
	# set speed
	barrier_speed = speed
	# set x and (random) y-position
	position.x = window_size.x
	position.y = randf_range(16, window_size.y - barrier_size.y - 16)
	# randomize color
	var rand_color = Color(randf(), randf(), randf(), 1)
	$ColorRect.color = rand_color


# handle collision
func _on_body_entered(body: Node2D) -> void:
	Signalbus.player_death.emit()
	queue_free()
