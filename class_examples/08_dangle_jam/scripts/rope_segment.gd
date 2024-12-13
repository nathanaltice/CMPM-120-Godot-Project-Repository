extends RigidBody2D

@onready var audio_player: AudioStreamPlayer2D = $BaseAudioPlayer
@onready var sprite_shape: Sprite2D = $SpriteShape
@onready var flash_timer: Timer = $FlashTimer

var pitch_options: Array = [ 1, 1.5, 2]

func _ready() -> void:
	# Connect timer signal to function
	if not flash_timer.timeout.is_connected(_on_flash_timer_timeout):
		flash_timer.timeout.connect(_on_flash_timer_timeout)

func _on_body_entered(_body: Node) -> void:
	play_sound()
	flash()

func flash() -> void:
	# Fade the sprite to 50%
	sprite_shape.modulate.a = 0.5
	# Start the timer
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	# Reset to original alpha
	sprite_shape.modulate.a = 1
	
func play_sound() -> void:
	
	# Create a new audio player instance
	var new_audio_player = AudioStreamPlayer2D.new()
	
	# Attach the wav file
	new_audio_player.stream = audio_player.stream
	
	# Pick a random pitch from the pitch_options array
	new_audio_player.pitch_scale = pitch_options.pick_random()
	
	# Make sure it's playing through the right audio bus
	new_audio_player.bus = "Chimes"
	
	# Add it to the scene
	add_child(new_audio_player)
	
	# Play the sound
	new_audio_player.play()
	
	# Remove the audio player once you're done
	new_audio_player.finished.connect(
		func(): new_audio_player.queue_free()
	)
