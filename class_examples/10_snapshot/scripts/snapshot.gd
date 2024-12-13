extends Node2D

var snapshot_image: Image

@onready var close_button: TextureButton = $CloseButton
@onready var snapshot_sprite: Sprite2D = $SnapshotImage

func _on_close_button_pressed() -> void:
	queue_free()

func process_texture() -> void:
	# This function updates the value of each pixel of the input
	# image to be either black or white.
	add_image_filter(snapshot_image)
	# Create a new texture from the image
	var snapshot_texture = ImageTexture.create_from_image(snapshot_image)
	# Apply the texture to the sprite
	snapshot_sprite.texture = snapshot_texture
	# Change the scale of the sprite.
	snapshot_sprite.scale = Vector2(0.5, 0.5)

	# Get the viewport size (screen size)
	var viewport_size = get_viewport_rect().size
	var sprite_size = snapshot_texture.get_size() * snapshot_sprite.scale
	
	position = (viewport_size / 2) - (sprite_size / 2)
	rotate(randf_range(-0.1, 0.1))


func add_image_filter(image) -> Image:
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel = image.get_pixel(x, y)
			var gray = pixel.r * 0.299 + pixel.g * 0.587 + pixel.b * 0.114
			var threshold = 0.5
			var contrast = 1.5
			gray = (gray - threshold) * contrast + threshold
			gray = clamp(gray, 0.0, 1.0)
			image.set_pixel(x, y, Color(gray, gray, gray))
	return image 
