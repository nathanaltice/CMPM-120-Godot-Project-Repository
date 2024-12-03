extends StaticBody2D

# Constant Variables
const BAD_TEXTURE: Resource = preload("res://Assets/Hurt Square.png")


# determines if a tile is a good or bad tile to stand on. This variable has a
# setter function.
@export var isGoodTile = true:
	set(value):
		isGoodTile = value
		SetTileState()



# This function will change whether or not the player can collide with this tile
# tile_enabled: If the player can collide with the tile or not.
func disable_collision(tile_enabled: bool):
	# because godot uses ".disaled", we need to flip our incoming boolean. If
	# the user wants the collision to be enabled, then we make disabled = false.
	# the user wants the collision to be disabled, then we make disabled = true.
	
	$CollisionShape2D.disabled = not tile_enabled
	# if the tile is good, we never want to enable the Area2D
	$Area2D/CollisionShape2D.disabled = not tile_enabled and not isGoodTile



# This is a function that is signaled from Area2D. This function should only run
# when this is marked as a bad tile
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Defensive case: Area2D accidentally turned on
	if(isGoodTile): return
	
	# If the body that entered the trigger is the player...
	if(body.name == "Player"):
		# If the body has a method for disabling movement...
		if(body.has_method("disable_movement")):
			# Kill the player
			body.disable_movement(true)



# This function sets the properties of whether this is a good time or a bad
# tile.
func SetTileState():
	if(isGoodTile):
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Sprite2D.texture = BAD_TEXTURE
		$Area2D/CollisionShape2D.disabled = false
