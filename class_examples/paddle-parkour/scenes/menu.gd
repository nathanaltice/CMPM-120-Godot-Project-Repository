extends Node

const COLOR_BAR_WIDTH : int = 24
const SCENE_TRANSITION_TIME = 1.5

var color_bar : PackedScene = preload("res://scenes/color_bar.tscn")
var window_size : Vector2
var input_unlocked := true

@onready var shader_rect = $ShaderLayer/ColorRect
@onready var background_music = $BGM

func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	
	# create row of color bars
	create_color_bars()
	
	# tween shader aberration property
	var aberration_tween = create_tween().set_loops()
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0.2, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0.02, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", -0.2, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0.02, 5)

	# play music
	background_music.play()


func _process(_delta: float) -> void:
	# monitor player input
	if Input.is_action_just_pressed("menu_select") and input_unlocked:
		scene_transition()


func create_color_bars() -> void:
	# calculate number of bars to draw based on window width
	var num_bars = window_size.x / COLOR_BAR_WIDTH
	
	# note: drawing the bars could be done in one nested loop, but I've left two separate loops for clairty
	# top bars
	for i in num_bars:
		var bar = color_bar.instantiate()
		add_child(bar)
		bar.add_to_group("colorbars")
		bar.position = Vector2(i * COLOR_BAR_WIDTH, 0 - bar.size.y / 2 - randi_range(0, bar.size.y / 2))
		bar.start_yoyo_tween()
	# bottom bars
	for i in num_bars:
		var bar = color_bar.instantiate()
		add_child(bar)
		bar.add_to_group("colorbars")
		bar.position = Vector2(i * COLOR_BAR_WIDTH, window_size.y - bar.size.y / 2 - randi_range(0, bar.size.y / 2))
		bar.start_yoyo_tween()


func scene_transition() -> void:
	# lock input during transition
	input_unlocked = false
	
	# play SFX
	$RevSFX.play()
	$SwellSFX.play()
	
	# spawn fake player paddle
	var paddle = ColorRect.new()
	add_child(paddle)
	paddle.size = Vector2(24, 120)
	paddle.color = Color(1, 1, 1, 1)
	paddle.position = Vector2(window_size.x, window_size.y / 2 - paddle.size.y / 2)
	
	# fade out color bars
	var bar_tween = create_tween()
	var bars = get_tree().get_nodes_in_group("colorbars")
	for bar in bars:
		# note: parallel() is necessary to make all bars tween simultaneously
		bar_tween.parallel().tween_property(bar, "modulate:a", 0, SCENE_TRANSITION_TIME)
	
	# set up parallel tweens
	var menu_tween = create_tween()
	menu_tween.tween_property($ColorBand, "position:x", $ColorBand.size.x, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($TitleControl, "position:x", -$TitleControl.size.x, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property(paddle, "position:x", 48, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($LabelControl, "modulate:a", 0, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($LabelControl/Borders/TopBorder, "position:y", -40, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($LabelControl/Borders/RightBorder, "position:x", 1128, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($LabelControl/Borders/BottomBorder, "position:y", 624, SCENE_TRANSITION_TIME)
	menu_tween.parallel().tween_property($LabelControl/Borders/LeftBorder, "position:x", -40, SCENE_TRANSITION_TIME)
	await menu_tween.finished
	
	# proceed to next scene
	get_tree().change_scene_to_file("res://scenes/play.tscn")
