extends Node2D

@onready var ball_timer: Timer = $BallTimer

@export var ball: PackedScene

# Called when the node enters the scene tree 
# for the first time.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if ball_timer.is_stopped():
			# Use get_global_mouse_position to get position of mouse.
			spawn_ball(get_global_mouse_position())
			ball_timer.start()


func spawn_ball( mousePosition: Vector2) -> void:
	print("Click position: ", mousePosition)
	# Create a new instance of the ball
	var ballInstance = ball.instantiate()
	# Set the position of the instance
	ballInstance.position = mousePosition
	# Add the instance to the scene
	add_child((ballInstance))
