extends Area2D

var ship_speed : int = 500
var ship_size
var ship_start_position_y
var ship_score : int
var screen_dimensions

var explosion = preload("res://scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# store sizes and positions
	screen_dimensions = get_window().size
	ship_size = $Sprite2D.get_rect().size
	ship_start_position_y = position.y	# store starting y-position since ships will be instanced by main


func set_ship_position(x, y) -> void:
	position.x = x
	position.y = y


func set_ship_score_value(score_value) -> void:
	ship_score = score_value


func _process(delta: float) -> void:
	# move ship left
	position.x -= ship_speed * delta
	# wrap around screen edge
	if position.x < 0 - ship_size.x:
		position.x = screen_dimensions.x

# handles enemy/missile collision
func _on_area_entered(area: Area2D) -> void:
	# instantiate ship explosion
	var ship_explosion = explosion.instantiate()
	ship_explosion.get_node("AnimatedSprite2D").global_position.x = global_position.x
	ship_explosion.get_node("AnimatedSprite2D").global_position.y = global_position.y
	add_child(ship_explosion)
	$ShipExplodeSFX.play()
	
	# reset ship + missile position
	set_ship_position(screen_dimensions.x + randi_range(ship_size.y, ship_size.y * 3), ship_start_position_y)
	area.get_parent().reset_missile()
	
	# add score
	get_parent().award_points(ship_score)
	
