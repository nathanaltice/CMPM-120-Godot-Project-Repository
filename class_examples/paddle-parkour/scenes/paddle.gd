extends CharacterBody2D


var window_size : Vector2		# stores window size
var speed : float = 500			# player paddle speed
var paddle_size : Vector2		# stores paddle size
var direction : Vector2			# stores paddle direction


func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	paddle_size = $ColorRect.get_size()
	direction = Vector2(0, 0)
	
	
func _process(delta: float) -> void:
	# handle player input
	if Input.is_action_pressed("paddle_up"):
		direction.y = -1
	if Input.is_action_pressed("paddle_down"):
		direction.y = 1
	
	move_and_collide(direction * speed * delta)
	
	# limit player's vertical paddle position
	position.y = clamp(position.y, 0, window_size.y - paddle_size.y)


# places player paddle at center left edge of the screen
func position_paddle():
	position.x = 32
	position.y = window_size.y / 2 - paddle_size.y / 2
	
