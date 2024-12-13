extends Node2D

@onready var bounciness_slider = $UI/BouncinessSlider
@onready var bounciness_label = $UI/BouncinessLabel
@onready var shape_options: OptionButton = $UI/ShapeOptions

var Shape = preload("res://scenes/shape.tscn")
	
# Signal on slider change
func _on_bounciness_slider_value_changed(value: float) -> void:
	bounciness_label.text = "Bounciness: %.2f" % value

# Because the UI needs to be clicked as well, we'll use 
# _unhandled input so balls aren't instantaited when the
# user clicks the slider.
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		spawn_bouncy_toy(get_global_mouse_position())


func spawn_bouncy_toy(position):
	# Create a new ball
	var new_shape = Shape.instantiate()
	# Add shape to scene (so that _ready can be used)
	add_child(new_shape)
	# Use init() to apply settings
	new_shape.init(position, bounciness_slider.value, shape_options.selected)
	
