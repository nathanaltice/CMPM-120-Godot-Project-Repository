extends StaticBody2D

var ball_pos : Vector2		# ball's current position
var dist : int				# vertical distance between AI paddle and ball
var move_by : int			# how far should AI paddle move
var win_height : int			# window height
var p_height: int			# paddle height


func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y


func _process(delta: float) -> void:
	# move paddle toward ball
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	
	if abs(dist) > get_parent().PADDLE_SPEED * delta:
		# Note: the if checks whether dist > than maximum paddle movement speed
		move_by = get_parent().PADDLE_SPEED * delta * (dist / abs(dist))
		# Note: the (dist / abs(dist)) portion captures the ball's y-direction
		# the abs value is always positive, so the dist determines the sign, ie the direction
	else:
		move_by = dist
		
	position.y -= move_by
	
	# limit paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
