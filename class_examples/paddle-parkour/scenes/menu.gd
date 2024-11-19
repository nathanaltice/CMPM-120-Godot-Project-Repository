extends Node

var color_bar : PackedScene
const BAR_WIDTH : int = 24
var window_size : Vector2

func _ready() -> void:
	# get our dimensions
	window_size = get_window().size
	
	# create row of color bars
	color_bar = preload("res://scenes/color_bar.tscn")
	create_color_bars()
	
	# tween shader aberration property
	var aberration_tween = create_tween().set_loops()
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0.2, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0.02, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", -0.2, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0.02, 5)


func _process(delta: float) -> void:
	# handle player input
	if Input.is_action_just_pressed("menu_select"):
		get_tree().change_scene_to_file("res://scenes/play.tscn")	# change to play scene


func create_color_bars() -> void:
	var num_bars = window_size.x / BAR_WIDTH
	
	# top bars
	for i in num_bars:
		var bar = color_bar.instantiate()
		add_child(bar)
		bar.position = Vector2(i * BAR_WIDTH, 0 - bar.size.y / 2 - randi_range(0, bar.size.y / 2))
		bar.start_yoyo_tween()
	# bottom bars
	for i in num_bars:
		var bar = color_bar.instantiate()
		add_child(bar)
		bar.position = Vector2(i * BAR_WIDTH, window_size.y - bar.size.y / 2 - randi_range(0, bar.size.y / 2))
		bar.start_yoyo_tween()
