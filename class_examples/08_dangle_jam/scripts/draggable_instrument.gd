extends StaticBody2D

@export var audio_file: AudioStreamWAV
@export var instrument_texture: CompressedTexture2D

@onready var collision_area: Area2D = $InstrumentArea
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var instrument_sprite: Sprite2D = $InstrumentSprite

var is_dragging = false
var drag_start_position = Vector2.ZERO


func _ready():
	# Connect the area's body_entered signal
	collision_area.body_entered.connect(_on_body_entered)
	input_event.connect(_on_input_event)
	audio_player.stream = audio_file
	instrument_sprite.texture = instrument_texture

func _on_body_entered(body):
	if body.name == "InstrumentTrigger":
		audio_player.play()
		
		# Create the scale tween
		var tween = create_tween()
		tween.tween_property(instrument_sprite, "scale", Vector2(1.5, 1.5), 0.12)
		tween.tween_property(instrument_sprite, "scale", Vector2(0.5, 0.5), 0.25)
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Toggle dragging
			is_dragging = event.pressed
			
			# When starting drag, capture the offset
			if is_dragging:
				drag_start_position = get_global_mouse_position() - global_position

func _process(_delta):
	# Update position while dragging
	if is_dragging:
		global_position = get_global_mouse_position() - drag_start_position
