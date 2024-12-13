extends RigidBody3D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var timer: Timer = $Timer

var audio_file: AudioStreamWAV

func _ready() -> void:
	# Make sure light starts off
	omni_light_3d.visible = false
	# Connect timer timeout signal
	timer.timeout.connect(_on_timer_timeout)


func _on_body_entered(_body: Node) -> void:
	# We don't want to trigger light/sound on every collision,
	# just the ones with the "bumps" mesh in the blender file.
	
	# First, get the path of the body and conver it to a string.
	var path = str(_body.get_path())
	
	# Then check to make sure it matches the mesh name.
	if "bumps" in path:
  
		# Play the sound.
		audio_player.stream = audio_file
		audio_player.play()

		# Turn on light
		omni_light_3d.visible = true
		# Start timer
		timer.start()


func _on_timer_timeout() -> void:
	# Turn off light when timer finishes
	omni_light_3d.visible = false
