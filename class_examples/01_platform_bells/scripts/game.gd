extends Node2D

@onready var ball_timer: Timer = $BallTimer
@export var ball: PackedScene

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if ball_timer.is_stopped():
			# Weird. For some reason event.position is offset
			spawn_ball(get_global_mouse_position())
			ball_timer.start()

func spawn_ball( mousePosition: Vector2) -> void:
	print(mousePosition)
	var ballInstance = ball.instantiate()
	ballInstance.position = mousePosition
	add_child((ballInstance))
