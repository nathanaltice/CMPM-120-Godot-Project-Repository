extends Node


var window_size : Vector2
var player_paddle : PackedScene
var player


func _ready() -> void:
	window_size = get_window().size
	player_paddle = preload("res://scenes/paddle.tscn")
	
	# start game
	game_start()


func _process(delta: float) -> void:
	pass


func game_start():
	initialize_paddle()


func initialize_paddle():
	player = player_paddle.instantiate()
	add_child(player)
	player.position_paddle()
