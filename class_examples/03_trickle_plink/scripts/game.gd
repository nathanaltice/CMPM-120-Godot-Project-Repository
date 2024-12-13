extends Node2D

@onready var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		spawn_new_ball(get_global_mouse_position())

func spawn_new_ball(newBallPosition):
	# Create a new instance of the ball
	var new_toy = ball_scene.instantiate()
	
	# Set the new ball's position to the mouse position
	new_toy.global_position = newBallPosition
	
	# Add the new ball to the scene
	add_child(new_toy)
