extends Node2D

var window_size : Vector2
var player_paddle : PackedScene
var player
var barrier_paddle : PackedScene
@export var barrier_speed : int = 450
@export var barrier_speed_increment : int = 25
var survival_time : int


func _ready() -> void:
	randomize()
	
	# get our dimensions
	window_size = get_window().size
	
	# preload scenes
	player_paddle = preload("res://scenes/paddle.tscn")
	barrier_paddle = preload("res://scenes/barrier.tscn")
	
	# initialize game variables
	survival_time = 0
	
	# connect to custom signal(s)
	Signalbus.player_death.connect(_game_over)
	
	# start game
	game_start()


func _process(delta: float) -> void:
	pass


func game_start():
	initialize_paddle()
	spawn_barrier()
	$SurvivalTimer.start()
	
	# debug
	$HUD/DebugBSpeed.text = "b_speed: " + str(barrier_speed)


func _game_over():
	print('game over')
	$SurvivalTimer.stop()


func initialize_paddle():
	player = player_paddle.instantiate()
	add_child(player)
	player.position_paddle()


func spawn_barrier():
	var barrier = barrier_paddle.instantiate()
	add_child(barrier)
	barrier.initialize_barrier(barrier_speed)


func _on_survival_timer_timeout() -> void:
	# update survival time
	survival_time += 1
	$HUD/SurvivalTime.text = str(survival_time)
	
	# speed up and border color change every 5 seconds
	if survival_time % 5 == 0:
		barrier_speed += barrier_speed_increment
		change_border_colors()
		$Camera2D.apply_shake()
		
		# debug
		$HUD/DebugBSpeed.text = "b_speed: " + str(barrier_speed)


func change_border_colors() -> void:
	var borders = $Borders.get_children()
	for border in borders:
		border.color = Color(randf(), randf(), randf(), 1)
