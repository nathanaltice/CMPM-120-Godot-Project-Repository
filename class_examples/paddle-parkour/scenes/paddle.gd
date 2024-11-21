extends CharacterBody2D

var window_size : Vector2		# stores window size
var speed : float = 500			# player paddle speed
var paddle_size : Vector2		# stores paddle size
var direction : Vector2			# stores paddle direction
var explosion_scene : PackedScene = preload("res://scenes/paddle_explosion.tscn")

@onready var paddle_rectangle = $ColorRect


func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	paddle_size = paddle_rectangle.get_size()
	
	# set paddle properties
	direction = Vector2(0, 0)
	z_index = 10
	
	# connect to custom signal(s)
	Signalbus.player_died.connect(_remove_paddle)


func _process(delta: float) -> void:
	# handle player input
	if Input.is_action_pressed("paddle_up"):
		direction.y = -1
	if Input.is_action_pressed("paddle_down"):
		direction.y = 1
	
	move_and_collide(direction * speed * delta)
	
	# limit paddle's vertical position
	position.y = clamp(position.y, 24, window_size.y - paddle_size.y * scale.y - 24)


# places player paddle at center left edge of the screen
func position_paddle():
	position.x = 48
	position.y = window_size.y / 2 - paddle_size.y / 2


# half-size the paddle's height
func shrink():
	scale.y = 0.5


func _remove_paddle():
	# instance particle explosion and set to paddle position/scale
	var explosion = explosion_scene.instantiate()
	get_parent().add_child(explosion)
	explosion.emitting = true
	explosion.one_shot = true
	explosion.position = position
	explosion.position.y += paddle_size.y / 2
	explosion.scale.y = scale.y
	
	# release node
	queue_free()
