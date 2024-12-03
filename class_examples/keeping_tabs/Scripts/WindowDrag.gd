extends Area2D

# Floor Node Variables
const TILE_ROWS = 4
const TILE_COLUMNS = 5
const TILE_LENGTH = 80
const TILE_COLUMN_TOP = 40
const TILE_ROW_LEFT = -160
const window_tile: Resource = preload("res://Scenes/Window Parts/Good Window Tile.tscn")


# Mouse Variables
var mouse_inside = false
var mouse_offset = Vector2(0,0)

# Moving Variables
var can_move = true
var waiting_move = false
var mouse_is_down = false



# Respawning Variables
var spawn_position: Vector2 = Vector2.ZERO

# The window patterns that can be randomly generated:
# 0 = no tile, 1 = good tile, 2 = bad tile
const TILE_PATTERNS = [[0,0,0,0,0, # Each index is an array for what tiles will go
						0,0,0,0,0, # where. Notice how the new lines make it look
						0,0,0,0,0, #like it's a 5x4 matrix.
						1,1,1,1,1],
						
					   [0,0,0,0,0,
						0,0,0,1,1,
						0,1,2,0,0,
						1,0,0,0,0],
						
					   [0,0,0,0,0,
						1,0,0,0,0,
						1,0,0,0,1,
						1,1,1,1,1],
						
					   [0,2,2,2,2,
						0,0,0,0,0,
						0,0,0,0,0,
						1,1,2,1,1],
						
					   [0,0,0,0,0,
						0,0,2,0,0,
						0,0,2,0,0,
						1,1,1,1,1],
						
					   [0,0,0,0,0,
						1,0,0,0,0,
						1,0,0,0,1,
						1,1,1,1,1],
					
					   [0,0,0,0,0,
						0,0,0,0,0,
						1,1,0,0,1,
						2,2,2,2,2],
					
					   [0,0,0,0,1,
						0,0,0,0,1,
						1,2,2,0,0,
						1,1,1,1,1],
						
					   [0,0,0,0,0,
						0,1,0,1,0,
						1,0,0,0,1,
						1,2,2,2,1],
						
					   [0,0,0,0,0,
						1,0,1,0,1,
						1,2,1,2,1,
						1,2,1,2,1],
					
					   [0,0,0,0,0,
						1,0,0,0,1,
						1,0,0,0,1,
						1,2,2,2,1],]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#set the tiles in this window
	var random_tile_pattern = randi_range(0, TILE_PATTERNS.size() - 1)
	spawn_tiles(random_tile_pattern)
	
	# Set the spawn position
	spawn_position = position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# if the mouse is inside the window bar, check if clicking and that the
	# player isnt inside
	if(mouse_inside):
		_check_if_clicking()
	
	# if the mouse can move and the player is clicking, then move the window
	if(mouse_is_down):
		_move_window()



# This signal function is called whenever the player's mouse enters the dragable
# window area.
func _on_mouse_entered():
	mouse_inside = true



# This signal function is called whenever the player's mouse leaves the dragable
# window area.
func _on_mouse_exited():
	mouse_inside = false



# This signal function checks if the player entered this window. This it to make
# sure the player move the window while they're standing in it.
func _on_player_enter_window(body: Node2D) -> void:
	if(body.name == "Player"):
		can_move = false;
		print("player prevented moving")



# This signal function checks if the player left this window. This it to make
# sure the window can move once the player leaves it.
func _on_player_exit_window(body: Node2D) -> void:
	if(body.name == "Player"):
		can_move = true;
		print("player enabled moving")



# this function checks to see if the player clicked or released the mouse.
func _check_if_clicking() -> void:
	
	# If the player is clicking
	if(Input.is_action_just_pressed("Mouse Click") and can_move):
		# Set the offset
		mouse_offset = position - get_global_mouse_position()
		change_collision(false)
		
		#start clicking
		mouse_is_down = true
	
	# else, if first frame of not clicking, stop clicking and enable collisions
	elif(Input.is_action_just_released("Mouse Click")):
		mouse_offset = Vector2(0,0)
		change_collision(true)
		mouse_is_down = false



# This function moves the window if the player is dragging the window across
# the screen.
func _move_window() -> void:
	var mouse = get_global_mouse_position()
	position = mouse + mouse_offset



# This function enables or disables the collision of all the tiles inside this
# window. This will be called when the player starts and stops dragging a
# window.
func change_collision(newCollisionState):
	for node in $"Floor Nodes".get_children():
		node.disable_collision(newCollisionState)



# This function spawns all the tiles that will exist inside of this window at
# the window's instantiation. from pattern_index, it will select the associated
# index in 
func spawn_tiles(pattern_index: int):
	var tile_position_y = TILE_COLUMN_TOP
	var tile_position_x = TILE_ROW_LEFT
	
	for i in TILE_COLUMNS:
		for j in TILE_ROWS:
			var block_id = TILE_PATTERNS[pattern_index][(j * TILE_COLUMNS) + i]
			
			if(block_id > 0):
				var new_tile = window_tile.instantiate()
				new_tile.isGoodTile = (block_id <= 1) # set if bad tile
				
				$"Floor Nodes".add_child(new_tile)
				new_tile.position = Vector2(tile_position_x, tile_position_y)
			
			tile_position_y += TILE_LENGTH
		
		tile_position_y = TILE_COLUMN_TOP
		tile_position_x += TILE_LENGTH


# This function respawns this window to its original location.
func respawn() -> void:
	position = spawn_position
	mouse_offset = Vector2(0,0)
	change_collision(true)
	mouse_is_down = false
