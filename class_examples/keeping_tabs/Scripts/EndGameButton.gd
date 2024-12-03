extends Control

# Class Note: This class is for the buttons that restart and end the level. I 
# Did this because I realized that I only need one on screen button that changes
# functionality depending on game conditions, so I only cretaed one button that
# changes functionality.


# Constant Variables
const RESTART_TEXT: String = "Try Again?"
const WIN_TEXT: String = "Next Level?"
const FADE_DURATION: float = 1


# Component Variables
@onready var button: Button = $Button
@onready var white_fade: ColorRect = $Background

# button type variables
var is_restart_button: bool = true;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the spawn to where the player starts
	button.visible = false
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	var tween = create_tween()
	tween.tween_property(white_fade, "color", Color(1,1,1,0), FADE_DURATION)

# This is a signal function that transitions to a new level when the player
# clicks the "Next Level" button.
func _on_button_button_up() -> void:
	var root_node = get_tree().root.get_child(0)
	
	# If this is a restart button, restart the level
	if(is_restart_button and root_node.has_method("reload_level")):
		# Prevent button from being pressed
		button.visible = false
		set_mouse_filter(Control.MOUSE_FILTER_PASS)
		
		# Fade the level out
		var tween = create_tween()
		tween.tween_property(white_fade, "color", Color(1,1,1,1), FADE_DURATION) # Fade up
		tween.tween_property(white_fade, "color", Color(1,1,1,0), FADE_DURATION) # Fade down
		await get_tree().create_timer(FADE_DURATION).timeout
		root_node.reload_level()
	
	# If this is a next level button, load the next level
	if(not is_restart_button and root_node.has_method("load_loading_screen")):
		# Prevent button from being pressed
		button.visible = false
		
		# Fade the level out
		var tween = create_tween()
		tween.tween_property(white_fade, "color", Color(1,1,1,1), FADE_DURATION)
		
		# Wait for fade to finish
		await get_tree().create_timer(FADE_DURATION).timeout
		root_node.load_loading_screen()



# This is a signal function from the win button. This enables the button for the
# player to go to the next level
func _on_player_won_level() -> void:
	set_mouse_filter(Control.MOUSE_FILTER_STOP)
	is_restart_button = false
	button.visible = true
	button.text = WIN_TEXT



# This is a signal function from the player. This enables the button for the
# player to restart the level when they die
func _on_player_died() -> void:
	set_mouse_filter(Control.MOUSE_FILTER_STOP)
	is_restart_button = true
	button.visible = true
	button.text = RESTART_TEXT
