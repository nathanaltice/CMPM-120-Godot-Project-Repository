extends Node

signal start_loading_next_signal
signal finished_loading_signal


# Constant Variables
const LOADING_TIME: float = 3
const FADE_DURATION: float = 1
const TEXT_FADE_TIME: float = 1.25

# Loading Variables
var max_bar_size: float = 1
var can_load: bool = false
var can_press: bool = true

# Loading Bar Components
@onready var loading_bar = $"Loading Bar"

# UI Components
@onready var white_fade = $"UI/Background"
@onready var next_button = $"UI/Button"

# Text Components
@onready var loading_title = $"Labels/Title Label"
@onready var tip_title = $"Labels/Tip Title"
@onready var tip_text = $"Labels/Tip Text"

# Tip Variables
var tips: Array = ["Nicholas Nolasco Made this demo!",
				   "Nathan Altice is my favorite professor.",
				   "Go to a Perks Coffee Bar before a 9AM class.",
				   "Every programming question can be solved with a dictionary.",
				   "I still don't know who Foo and Bar are...",
				   "I wonder if it hurts Chat GPT to close the window...",
				   "Sitting in the front row means you learn more.",
				   "hitting snooze will always end in disaster.",]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	next_button.visible = false
	
	max_bar_size = loading_bar.size.x
	loading_bar.size.x = 0
	
	_tween_fade(false)
	_tween_text()
	
	# Make it so everyone else has to wait
	_wait_to_load(FADE_DURATION)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
'''
	if can_load:
		var loading_percentage: float = (loading_bar.size.x/max_bar_size)
		loading_percentage = loading_percentage + (delta / LOADING_TIME)
		
		if(loading_percentage > 1):
			can_load = false
			_tween_fade(true)
			_load_next_after_fade(FADE_DURATION)
		
		else:
			loading_percentage = loading_percentage
			loading_bar.size.x = loading_percentage * max_bar_size
'''



func _on_button_button_up() -> void:
	if(can_press):
		can_press = false
		_tween_fade(true)
		_load_next_after_fade(FADE_DURATION)




func recieve_loading_percentage(progress: float) -> void:
	if(can_load):
		
		print("loading percentage: " + str(progress))
		
		# Set the scale of the loading bar
		loading_bar.size.x = progress * max_bar_size
	
		# see if done loading
		if(progress == 1):
			can_load = false
			next_button.visible = true


# This function waits a certain ammount of time before loading the next scene.
# This function supports waiting for the screen to fully fade in before
# starting the loading bar.
func _wait_to_load(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	can_load = true
	start_loading_next_signal.emit()
	print("started loading")



# This  function loads the next level after the screen fades out. This function
# supports waiting for the screen to turn white before loading the next level.
# seconds: float = the time to wait before allowing the the next level to load.
func _load_next_after_fade(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	finished_loading_signal.emit()



# This function fades the screen to or from a white screen with a tween.
# fade_to_white: bool = Whether the screen fades to write or from white
func _tween_fade(fade_to_white: bool) -> void:
	var tween = create_tween()
	var white = Color(1,1,1,1)
	var transparent = Color(1,1,1,0)
	
	if fade_to_white:
		white_fade.color = transparent
		tween.tween_property(white_fade, "color", white, FADE_DURATION)
	else:
		white_fade.color = white
		tween.tween_property(white_fade, "color", transparent, FADE_DURATION)



# This function fades the text on screen in with a tween.
func _tween_text() -> void:
	var tween = create_tween()
	var font_color_path = "theme_override_colors/font_color"
	var transparent_color = Color(0,0,0,0);
	var final_color = Color(0,0,0,1);
	
	# Tween the title text
	loading_title.set(font_color_path, transparent_color)
	tween.tween_property(loading_title, font_color_path, final_color, TEXT_FADE_TIME)
	
	# Allow the loading title and tip title to run at the same time
	tween.set_parallel(true)
	
	# Tween the tip title text
	tip_title.set(font_color_path, transparent_color)
	tween.tween_property(tip_title, font_color_path, Color(0,0,0,1), TEXT_FADE_TIME)
	
	# Allow the tip text to load later
	tween.set_parallel(false)
	
	# Tween the tip text
	tip_text.text = tips[randi_range(0, tips.size() - 1)]
	tip_text.set(font_color_path, transparent_color)
	tween.tween_property(tip_text, font_color_path, final_color, TEXT_FADE_TIME)
