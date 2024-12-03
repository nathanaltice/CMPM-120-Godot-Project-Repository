extends CharacterBody2D

# Signal variables
signal player_died

# Constant Variables
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Moving And Spawning Variables
var can_move = true
var spawn: Vector2 = Vector2.ZERO

# Animation Variables
var sprite_scale: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the spawn to where the player starts
	spawn = position
	sprite_scale = $Sprite2D.scale.x



# Called during the physics processing step of the main loop.
func _physics_process(delta: float) -> void:
	
	if(not can_move): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Sprite2D.play("Falling")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Choose which animation to play
	_choose_animation(direction)	
	
	move_and_slide()



# This function chooses what animation the mouse character will play as the
# player traverses the game
func _choose_animation(direction: float) -> void:
	
	# If the character is falling
	if not is_on_floor():
		$Sprite2D.play("Falling")
	
	# If the character is walking
	elif(direction != 0):
		$Sprite2D.play("Walking")
		# Choose which direction the sprite should face
		if(direction < 0):
			$Sprite2D.scale.x = -sprite_scale
		else:
			$Sprite2D.scale.x = sprite_scale
	
	# Else, the character is standing still
	else:
		$Sprite2D.play("Idle")



# This function doesn't allow the player to move. This will be called when the
# player wins the level or the player dies.
# kill_player: a bool to say if the player should've died or not
func disable_movement(kill_player: bool):
	can_move = false
	
	if(kill_player):
		player_died.emit()


# This function respawns the player.
func respawn() -> void:
	position = spawn
	can_move = true
