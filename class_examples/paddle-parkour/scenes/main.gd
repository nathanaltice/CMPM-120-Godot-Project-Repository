extends Node

var menu_scene : PackedScene


func _ready() -> void:
	# get menu scene ready
	menu_scene = preload("res://scenes/menu.tscn")
	var menu = menu_scene.instantiate()
	add_child(menu)
