extends CharacterBody2D

var speed = 200

@onready var nav_agent = $NavigationAgent2D

func _physics_process(_delta):
	# Check to see if the target is reachable and make sure the agent has
	# not yet reached the target.
	if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
		var next_position = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_position)
		velocity = direction * speed
		
		# Move and slide is a built in function that triggers the movement.
		move_and_slide()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Set the nav agent postion to the current mouse position.
			nav_agent.target_position = get_global_mouse_position()
