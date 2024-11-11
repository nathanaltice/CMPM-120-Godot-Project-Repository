extends CharacterBody2D

var win_size : Vector2			# window size
const START_SPEED : int = 500	# ball starting speed
const BALL_SPEEDUP : int = 50	# ball moves faster as game progresses
var speed : int					# current ball speed
var dir : Vector2				# ball direction
const MAX_Y_VECTOR : float = 0.6	# max vector for bounce return angle


func _ready():
	win_size = get_viewport_rect().size


# pick a position / direction for the ball
func new_ball():
	# randomize start position / direction
	position.x = win_size.x / 2		# ball always starts in middle of screen
	position.y = randi_range(200, win_size.y - 200)
	
	speed = START_SPEED
	dir = random_direction()
	

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		# ball hits paddle?
		if collider == $"../Player" or collider == $"../CPU":
			speed += BALL_SPEEDUP
			dir = new_direction(collider)
		# ball hits wall?
		else:
			dir = dir.bounce(collision.get_normal())


# generate a random direction vector
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()	# x-direction can only be left or right
	new_dir.y = randf_range(-1, 1)
	
	return new_dir.normalized()			# ensure vector is the same length regardless of direction


# return new direction based upon where ball hits paddle
func new_direction(collider):
	var ball_y = position.y				# current ball y-position
	var pad_y = collider.position.y		# current paddle y-position
	var dist = ball_y - pad_y			# distance between ball and paddle y-positions
	
	var new_dir := Vector2()	
	
	# flip horizontal direction
	if dir.x > 0:		# moving right
		new_dir.x = -1
	else:				# moving left
		new_dir.x = 1
	
	# determine vertical direction
	# Note: calculation in parenthesis returns ratio of distance from center
	# we then multiply that by the maximum y vector value
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	
	return new_dir.normalized()
	
	
