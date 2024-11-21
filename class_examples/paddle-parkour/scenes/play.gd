extends Node2D

const SPAWN_DELAY : int = 2
const RESTART_DELAY : float = 1.5
const BARRIER_SPEED_MAX : int = 1300

var window_size : Vector2
var player
var player_paddle : PackedScene = preload("res://scenes/paddle.tscn")
var barrier_paddle : PackedScene = preload("res://scenes/barrier.tscn")
var barrier_speed : int
var barrier_speed_increment : int = 25
var spawn_lock : bool
var input_unlocked : bool
var cam_tilt_direction = 1
var dodge_count : int = 0
var high_score : int = 0

@onready var game_results = $Results
@onready var results_restart_label = $Results/Restart
@onready var camera_view = $Camera2D
@onready var shader_rect = $ShaderLayer/ColorRect
@onready var dodge_count_label = $HUD/DodgeCount
@onready var border_nodes = $Borders
@onready var bgm_play = $BGM/GameBGM
@onready var bgm_wait = $BGM/WaitBGM
@onready var shake_sfx = $SFX/ShakeSFX
@onready var dodge_sfx = $SFX/DodgeSFX


func _ready() -> void:
	# randomize seed
	randomize()
	
	# get our dimensions
	window_size = get_window().size
	
	# initialize game variables
	dodge_count = 0
	high_score = 0
	spawn_lock = false
	input_unlocked = true
	
	# connect to custom signal(s)
	Signalbus.barrier_dodged.connect(_barrier_dodged)
	Signalbus.player_died.connect(_game_ended)
	
	# tween shader aberration property
	var aberration_tween = create_tween().set_loops()
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0.1, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", -0.1, 5)
	aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0, 5)
	
	# start game
	game_start()


func _process(_delta: float) -> void:
	if input_unlocked and spawn_lock:
		if Input.is_action_just_pressed("menu_select"):
			game_start()

	# DEBUG
	if Input.is_action_just_pressed("debug_toggle"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func game_start():
	# reset game state
	dodge_count = 0
	spawn_lock = false
	barrier_speed = 700
	dodge_count_label.text = "READY"

	# tween alpha of ready/dodge count text
	var alpha_tween = create_tween()
	alpha_tween.tween_property(dodge_count_label, "modulate:a", 0.25, SPAWN_DELAY)
	
	# position player paddle
	initialize_paddle()
	
	# shake camera
	camera_view.apply_shake()
	
	# play SFX
	shake_sfx.play()
	
	# prepare music
	bgm_play.volume_db = -2
	bgm_play.play()
	if bgm_wait.playing:
		bgm_wait.stop()
	
	# hide game results node
	game_results.hide()
	
	# create temp timer to give player a few seconds before barriers/timer starts
	await get_tree().create_timer(SPAWN_DELAY).timeout
	dodge_count_label.text = str(dodge_count)
	spawn_barrier()


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
	dodge_count_label.text = str(dodge_count)

	# play SFX
	dodge_sfx.play()
	
	# after every 5 dodges...
	if dodge_count % 5 == 0:
		# bump barrier speed
		barrier_speed += barrier_speed_increment
		
		# check speed limit
		if barrier_speed > BARRIER_SPEED_MAX:
			barrier_speed = BARRIER_SPEED_MAX
		
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
		aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0.2, 0.25)
		aberration_tween.tween_property(shader_rect, "material:shader_parameter/aberration", 0, 0.25)
		
		# play SFX
		shake_sfx.play()
	
	# shrink paddle at 50 dodges
	if dodge_count == 50:
		player.shrink()
	
	# RAINBOOOOOOOOOWS at 75 dodges
	if dodge_count == 100:
		$RainbowTimer.start()
	
	# debug
	#print(barrier_speed)

func _game_ended():
	# temporarily lock input
	input_unlocked = false
	
	# stop timer(s)
	$RainbowTimer.stop()
	
	# shake camera back into place
	camera_view.apply_shake()
	camera_view.rotation = 0
	
	# play SFX
	$SFX/SplodeSFX.play()
	
	# swap music with volume fade out/in
	bgm_wait.set("volume_db", -80)
	bgm_wait.play()
	
	var volume_tween = create_tween()
	volume_tween.parallel().tween_property(bgm_play, "volume_db", -80, 1.5)
	volume_tween.parallel().tween_property(bgm_wait, "volume_db", 0, 1.5)
	
	# tween alpha of ready/dodge count text
	var alpha_tween = create_tween()
	alpha_tween.tween_property(dodge_count_label, "modulate:a", 1, SPAWN_DELAY)
	
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
	restart_scale_tween.tween_property(results_restart_label, "rotation", deg_to_rad(-3), 1)
	restart_scale_tween.tween_property(results_restart_label, "rotation", deg_to_rad(0), 1)
	restart_scale_tween.tween_property(results_restart_label, "rotation", deg_to_rad(3), 1)
	restart_scale_tween.tween_property(results_restart_label, "rotation", deg_to_rad(0), 1)
	
	# wait a bit until player can restart
	await get_tree().create_timer(RESTART_DELAY).timeout
	input_unlocked = true


func change_border_colors() -> void:
	var borders = border_nodes.get_children()
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
