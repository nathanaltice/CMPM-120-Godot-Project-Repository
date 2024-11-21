extends ColorRect


func _ready() -> void:
	# randomize color
	color = Color(randf(), randf(), randf(), 1)


func start_yoyo_tween() -> void:
	# make rectangles tween up and down
	var rand_duration = randf_range(1, 3)
	var start_y = position.y
	var yoyo_tween = create_tween().set_loops()
	yoyo_tween.tween_property(self, "position", Vector2(position.x, start_y + size.y / 2), rand_duration)
	yoyo_tween.tween_property(self, "position", Vector2(position.x, start_y), rand_duration)
