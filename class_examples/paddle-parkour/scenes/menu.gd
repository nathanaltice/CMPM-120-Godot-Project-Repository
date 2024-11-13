extends Node


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# handle player input
	if Input.is_action_just_pressed("menu_select"):
		get_tree().change_scene_to_file("res://scenes/play.tscn")	# change to play scene
