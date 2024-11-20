extends Node2D

var window_size : Vector2
var player_paddle : PackedScene
var player
var barrier_paddle : PackedScene
@export var barrier_speed : int = 550
@export var barrier_speed_increment : int = 25
const SPAWN_DELAY : int = 2
var spawn_lock : bool
@onready var camera_view = $Camera2D
var cam_tilt_direction = 1
@onready var game_results = $Results
var dodge_count : int = 0
var high_score : int = 0
const WHITE_FULL_ALPHA := Color(1, 1, 1, 1)
const WHITE_PARTIAL_ALPHA := Color(1, 1, 1, 0.25)

func _ready() -> void:
	# randomize seed
	randomize()
	
	# get our dimensions
	window_size = get_window().size
	
	# preload scenes
	player_paddle = preload("res://scenes/paddle.tscn")
	barrier_paddle = preload("res://scenes/barrier.tscn")
	
	# initialize game variables
	dodge_count = 0
	high_score = 0
	spawn_lock = false
	
	# connect to custom signal(s)
	Signalbus.barrier_dodged.connect(_barrier_dodged)
	Signalbus.player_death.connect(_game_over)
	
	# tween shader aberration property
	var aberration_tween = create_tween().set_loops()
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0.1, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", -0.1, 5)
	aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0, 5)
	
	# start game
	game_start()


func _process(_delta: float) -> void:
	if spawn_lock:
		if Input.is_action_just_pressed("menu_select"):
			game_start()

	if Input.is_action_just_pressed("debug_toggle"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func game_start():
	# reset game state
	dodge_count = 0
	spawn_lock = false
	barrier_speed = 550
	$HUD/DodgeCount.text = "READY"
	#$HUD/DodgeCount.set("theme_override_colors/font_color", WHITE_FULL_ALPHA)
	#$ShaderLayer/ColorRect.material.set("shader_parameter/abberation", 0)
	
	# tween alpha of ready/dodge count text
	var alpha_tween = create_tween()
	alpha_tween.tween_property($HUD/DodgeCount, "modulate:a", 0.25, SPAWN_DELAY)
	
	# position player paddle
	initialize_paddle()
	
	# shake camera
	camera_view.apply_shake()
	
	# play SFX
	$ShakeSFX.play()
	
	# start music
	$BGM.volume_db = -2
	$BGM.play()
	
	# hide game results node
	game_results.hide()
	
	# create temp timer to give player a few seconds before barriers/timer starts
	await get_tree().create_timer(SPAWN_DELAY).timeout
	$HUD/DodgeCount.text = str(dodge_count)
	spawn_barrier()


func _game_over():
	# stop timer(s)
	$RainbowTimer.stop()
	
	# shake camera back into place
	camera_view.apply_shake()
	camera_view.rotation = 0
	
	# play SFX
	$SplodeSFX.play()
	var volume_tween = create_tween()
	volume_tween.tween_property($BGM, "volume_db", -80, 1.5)
	
	# tween alpha of ready/dodge count text
	var alpha_tween = create_tween()
	alpha_tween.tween_property($HUD/DodgeCount, "modulate:a", 1, SPAWN_DELAY)
	
	# shut down barrier spawns
	spawn_lock = true	# stop spawning new barriers
	get_tree().call_group("barriers", "remove")	# remove existing barriers
	
	# check for high score
	if dodge_count > high_score:
		high_score = dodge_count
		$Results/NewBest.show()
	else:
		$Results/NewBest.hide()
	
	# show game results
	game_results.show()
	
	# tween restart message
	var restart_scale_tween = create_tween().set_loops()
	restart_scale_tween.tween_property($Results/Restart, "rotation", deg_to_rad(-3), 1)
	restart_scale_tween.tween_property($Results/Restart, "rotation", deg_to_rad(0), 1)
	restart_scale_tween.tween_property($Results/Restart, "rotation", deg_to_rad(3), 1)
	restart_scale_tween.tween_property($Results/Restart, "rotation", deg_to_rad(0), 1)

func initialize_paddle():
	player = player_paddle.instantiate()
	add_child(player)
	player.position_paddle()


func spawn_barrier():
	if not spawn_lock:
		var barrier = barrier_paddle.instantiate()
		add_child(barrier)
		barrier.initialize_barrier(barrier_speed)


func _barrier_dodged() -> void:
	# update dodge count
	dodge_count += 1
	$HUD/DodgeCount.text = str(dodge_count)
	
	# play SFX
	$DodgeSFX.play()
	
	# speed up every 5 dodges
	if dodge_count % 5 == 0:
		barrier_speed += barrier_speed_increment
		change_border_colors()
		camera_view.apply_shake()
		
		# tween camera rotation
		var current_rotation = camera_view.rotation
		cam_tilt_direction *= -1
		var random_angle = randf_range(1, 5)
		var new_angle = current_rotation + deg_to_rad(random_angle) * cam_tilt_direction
		
		var camera_rotation_tween = create_tween()
		camera_rotation_tween.tween_property(camera_view, "rotation", new_angle, 0.25)
		
		# tween shader aberration property
		var aberration_tween = create_tween()
		aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0.2, 0.25)
		aberration_tween.tween_property($ShaderLayer/ColorRect, "material:shader_parameter/aberration", 0, 0.25)
		
		# play SFX
		$ShakeSFX.play()
	
	# shrink paddle at 50 dodges
	if dodge_count == 50:
		player.shrink()
	
	# RAINBOOOOOOOOOWS at 75 dodges
	if dodge_count == 75:
		$RainbowTimer.start()


func change_border_colors() -> void:
	var borders = $Borders.get_children()
	for border in borders:
		border.color = Color(randf(), randf(), randf(), 1)


func _on_rainbow_timer_timeout() -> void:
	# create "shadow paddles" at player position
	var rainbow_paddle = ColorRect.new()
	add_child(rainbow_paddle)
	rainbow_paddle.position = player.position
	rainbow_paddle.size = player.paddle_size
	rainbow_paddle.color = Color(randf(), randf(), randf(), 1)
	
	# fade alpha
	var fade_tween = create_tween()
	fade_tween.tween_property(rainbow_paddle, "color:a", 0, 0.75)
	fade_tween.tween_callback(rainbow_paddle.queue_free)
