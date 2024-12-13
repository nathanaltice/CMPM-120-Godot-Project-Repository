extends Node2D

@onready var shutter: TextureButton = $ShutterButton
@onready var camera_2d: Camera2D = $Camera2D
var captured_sprite: Sprite2D
var Snapshot = preload("res://scenes/snapshot.tscn")

func _ready():
	# Create the sprite that will hold our captured image
	captured_sprite = Sprite2D.new()
	add_child(captured_sprite)
	captured_sprite.z_index = 100
	captured_sprite.visible = false
	
	# Connect the button's pressed signal
	shutter.pressed.connect(_on_shutter_pressed)

func _on_shutter_pressed():
	capture_and_process()

func capture_and_process():
	# Get a reference to the current viewport 
	var viewport = get_viewport()

	# Wait for the next frame to be processed so 
	# the viewport is up to date. (Prevents capturing 
	# incomplete frames.)
	await get_tree().process_frame

	# Get the viewport's content as a texture 
	var viewport_texture = viewport.get_texture()

	# Create a new instance of the Snapshot scene
	var new_snapshot = Snapshot.instantiate()

	# Assign the "snapshot_image" property an image from the viewport.
	# (Passing in image rather than texture so it can be filtered.)
	new_snapshot.snapshot_image = viewport_texture.get_image()
	# Add the new snapshot to the scene
	add_child(new_snapshot)
	
	# Call the process_texture() function inside the instantiated 
	# snapshot node.
	new_snapshot.process_texture()

	
	
