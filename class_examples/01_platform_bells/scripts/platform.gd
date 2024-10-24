extends StaticBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var soundName: AudioStreamWAV
@onready var particles: CPUParticles2D = $CPUParticles2D

func play_audio() -> void:
	print("Hooooo")
	audio_player.stream = soundName
	audio_player.play()
	particles.restart()
	animation.play("bounce")
