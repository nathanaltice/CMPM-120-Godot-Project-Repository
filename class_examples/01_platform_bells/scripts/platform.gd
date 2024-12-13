extends StaticBody2D

@export var soundName: AudioStreamWAV

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var particles: CPUParticles2D = $CPUParticles2D

func ball_hit() -> void:
	print("Boing!")
	# Attach the wav file from the parent scene to the audio player
	audio_player.stream = soundName
	# Play the sound
	audio_player.play()
	# Trigger the particle system
	particles.restart()
	# Trigger the platform jiggle
	animation.play("bounce")
