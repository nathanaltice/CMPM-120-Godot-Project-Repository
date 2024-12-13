extends Node2D

@export var wheel_model: PackedScene
@export var ball_sound: AudioStreamWAV

@onready var viewport: SubViewport = $Wheel
@onready var slider: HSlider = %Slider

var wheel: Node3D 

# switch out models in the _enter_tree step. Doing it in _ready
# prevents access to the instantiated transform for some reason.
# (Credit to Claude for figuring out this one)

func _enter_tree() -> void:
	if wheel_model:
		# Wait until the tree is reacy to accept the new model
		# (Credit to Claude for figuring out this one)
		await get_tree().process_frame
		
		# -- OPTIONAL ---
		# You could just remove the original wheel model 
		# altogether but this makes placement much easier.
		
		# Get the existing wheel node
		var old_wheel = viewport.get_node_or_null("wheel")
		# Zap the old node
		if old_wheel:
			old_wheel.queue_free()
		# -- END OPTIONAL ----
			
		# Instantiate your assigned model.
		wheel = wheel_model.instantiate()  
		wheel.name = "wheel"
		viewport.add_child(wheel)
		
		# Make any adjustments you need to position/rotation.
		wheel.position = Vector3(0, 0, 0)
		wheel.rotation_degrees = Vector3(0, 0, 90)

		# Set sound
		var ball = viewport.get_node_or_null("Ball")
		ball.audio_file = ball_sound
		
		
func _process(delta: float) -> void:
	# For some reason if you don't check if the new instance is valid 
	# you wont' be able to access the transform.
	if is_instance_valid(wheel):  
		wheel.rotation.x += delta * slider.value
