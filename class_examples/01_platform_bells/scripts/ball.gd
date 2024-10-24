extends RigidBody2D

func _ready() -> void:
	contact_monitor = true  # Enable contact monitoring
	max_contacts_reported = 1 

func _on_body_entered(body: Node) -> void:
	print("Ouch!")
	if body.has_method("play_audio"):
		body.play_audio()
