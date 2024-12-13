extends Node2D

@onready var sfx: AudioStreamPlayer2D = $Peek_SFX
@onready var peek_clockwise: Sprite2D = $Peek_Zone_Clockwise
@onready var peek_counterclockwise: Sprite2D = $Peek_Zone_Counterclockwise

func set_peek_position(new_position) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	position = new_position
	visible = true
	if not sfx.playing:
		sfx.play()

func hide_peek() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = false
	if sfx.playing:
		sfx.stop()

func _process(delta: float) -> void:
	var rotate_speed = 0.5
	if visible:
		peek_clockwise.rotation += rotate_speed * delta
		peek_counterclockwise.rotation += (rotate_speed * -1) * delta
