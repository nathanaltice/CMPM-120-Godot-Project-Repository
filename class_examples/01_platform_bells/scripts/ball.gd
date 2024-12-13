extends RigidBody2D

func _on_body_entered(body: Node) -> void:
	# Check to make sure there's a method called "ball_hit" 
	# on the body that has been hit (ie. not another ball)
	if body.has_method("ball_hit"):
		body.ball_hit()
