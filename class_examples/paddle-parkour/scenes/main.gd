extends Node

var menu_scene : PackedScene = preload("res://scenes/menu.tscn")


func _ready() -> void:
	# get menu scene ready
	var menu = menu_scene.instantiate()
	add_child(menu)
