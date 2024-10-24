extends RigidBody2D  

@export var pitchAdjustment: float
@export var triggerAction: String

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
		
func _ready() -> void:
	gravity_scale = 0
		
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed(triggerAction) ):
		play_sound()	
		
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ( event is InputEventMouseButton and event.pressed ):
		play_sound()	
	
func play_sound() -> void: 
	# Get the bus index (assuming you named your bus "PitchShift")
	var bus_index = AudioServer.get_bus_index("Bum")
	
	# Get the pitch shift effect (assuming it's the first effect on the bus)
	var pitch_effect = AudioServer.get_bus_effect(bus_index, 1)

	# Change the pitch	
	pitch_effect.pitch_scale = pitchAdjustment
	
	# Rotate the opposite direction of current rotation
	# credit : Claude
	angular_velocity = 5.0 * (1 if randf() > 0.5 else -1)
	
	# Play the sound
	audio_player.play()
