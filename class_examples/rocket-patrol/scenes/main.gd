extends Node2D

# credits
# Nathan Altice 9/2/24
# Space Warfare Sprite Sheet by Puck: https://puszke.itch.io/space-warfare-sprite-sheet
# How to Make Infinite Backgrounds Godot: https://www.youtube.com/watch?v=FtKdg4gKL3w

# variables
var screen_size : Vector2i
var rocket_height : Vector2i
var scroll_speed : int = 300
const scroll_direction = Vector2(0, 1)
const NUM_ENEMY_SHIPS : int = 3
var score : int
var high_score : int = 0
var game_running : bool

@onready var parallax = $StarfieldBG

var enemy_ship = preload("res://scenes/enemy_ship.tscn")


func _ready() -> void:
	game_running = false
	$UI.get_node("GameOver").hide()
	screen_size = get_window().size
	rocket_height = $Rocket.get_node("Base").get_rect().size
	$GameStart.get_node("Button").pressed.connect(new_game)
	get_tree().paused = true

func _process(delta: float) -> void:
	if game_running:
		# scroll starfield
		parallax.scroll_offset += scroll_direction * scroll_speed * delta
		# update timer UI
		$UI.get_node("Time").text = "TIME: " + str(roundf($GameTimer.time_left))

func new_game() -> void:
	game_running = true
	get_tree().paused = false
	$GameStart.get_node("Button").hide()
	position_rocket()
	initialize_enemy_ships()
	
	score = 0
	
	$GameTimer.start()


func position_rocket():
	$Rocket.position.x = screen_size.x / 2
	$Rocket.position.y = screen_size.y - rocket_height.y


func initialize_enemy_ships() -> void:
	var starting_x_position = screen_size.x
	var starting_y_position = 128
	var ship_point_value = 50
	
	# instantiate ships
	for i in NUM_ENEMY_SHIPS:
		var ship = enemy_ship.instantiate()
		var ship_size = ship.get_node("Sprite2D").get_rect().size
		ship.set_ship_position(starting_x_position, starting_y_position)
		ship.set_ship_score_value(ship_point_value)
		starting_x_position += ship_size.y * 1.5
		starting_y_position += ship_size.x * 1.5
		ship_point_value -= 20	# ships closer to player are worth less
		add_child(ship)


func award_points(point_value) -> void:
	# update score + UI
	score += point_value
	$UI.get_node("Score").text = "SCORE: " + str(score)
	
	# update high score
	if score > high_score:
		high_score = score
		$UI.get_node("HiScore").text = "HI-SCORE: " + str(high_score)


func _on_game_timer_timeout() -> void:
	print("timer done")
	game_over()


func game_over() -> void:
	$GameStart.get_node("Button").show()
	$UI.get_node("GameOver").show()
	get_tree().paused = true
