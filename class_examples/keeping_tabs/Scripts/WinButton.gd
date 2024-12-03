extends Area2D

# Signal Variables
signal player_won_level


# This is a signal function that is called when a body enters the win button.
func _on_body_entered(body: Node2D) -> void:
	# If the player touches this win button
	if(body.name == "Player"):
		
		# If the player can be forced to stop moving
		if(body.has_method("disable_movement")):
			body.disable_movement(false)
		
		# Allow the player to move
		player_won_level.emit()
