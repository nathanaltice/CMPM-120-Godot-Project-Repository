extends StaticBody2D

# SIMPLEST POSSIBLE MOUSE DRAG

var is_dragging = false
var drag_start_position = Vector2.ZERO

func _ready():
	# Connect the area's body_entered signal
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Toggle dragging
			print("click")
			is_dragging = event.pressed
			
			# When starting drag, capture the offset
			if is_dragging:
				drag_start_position = get_global_mouse_position() - global_position

func _process(_delta):
	# Update position while dragging
	if is_dragging:
		global_position = get_global_mouse_position() - drag_start_position
