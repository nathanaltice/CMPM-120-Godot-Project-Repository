extends StaticBody2D

var win_height: int		# window height
var p_height: int		# paddle height

func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	

func _process(delta):
	# handle player input
	if Input.is_action_pressed("player_up"):
		position.y -= get_parent().PADDLE_SPEED * delta	# get_parent will access constant from other script
	elif Input.is_action_pressed("player_down"):
		position.y += get_parent().PADDLE_SPEED * delta
		
	# limit paddle movement to window height
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
