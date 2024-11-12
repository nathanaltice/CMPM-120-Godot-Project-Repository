extends CharacterBody2D


var window_size : Vector2			# stores window size
var barrier_size : Vector2			# stores barrier size
var barrier_speed : int				# stores barrier speed
const DEFAULT_SPEED : int = 350		# default starting speed
var barrier_color : Color


func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	barrier_size = $ColorRect.get_size()
	initialize_barrier()


func _process(delta: float) -> void:
	# move our barrier left
	var direction = Vector2(-1, 0)
	var collision = move_and_collide(direction * barrier_speed * delta)
	
	# check collision
	if collision:
		var collider = collision.get_collider()
		queue_free()
	
	# check for left edge exit
	if position.x < -barrier_size.x:
		print('barrier exit')
		queue_free()


func initialize_barrier(speed : int = DEFAULT_SPEED):
	barrier_speed = speed		# set speed
	position.y = randi_range(0, window_size.y - barrier_size.y)
