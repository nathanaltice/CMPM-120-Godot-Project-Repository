extends RigidBody2D

@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var color_sound_map = {
	"red": preload("res://assets/sounds/wind-bells.wav"),
	"green": preload("res://assets/sounds/clock-chime.wav"),
	"pink": preload("res://assets/sounds/bright-chime.wav"),
	"blue": preload("res://assets/sounds/clock-chime.wav"),
	"orange": preload("res://assets/sounds/clock-chime.wav"),
	"yellow": preload("res://assets/sounds/bright-chime.wav"),
}
# How many concurrent sounds do you want to allow?
@export var max_audio_players = 10
var audio_players = []
var current_player = 0

func _ready():
	# Create a set of AudioStreamPlayer2D nodes to accept the
	# overlapping sounds.
	for i in range(max_audio_players):
		var audio_player = AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_players.append(audio_player)

func _on_body_entered(body):
	if body is TileMapLayer:
		# Get the collision point
		var collision_point = collision_shape.global_position
		
		# Figure out which tile is at that point.
		# to_local() converts the point to be local to the TileMapLayer,
		#   (important if the layer has been moved or resized.)
		# local_to_map() then finds the tile at that position
		# (Thanks to Claude for this one.)
		var tile_pos = body.local_to_map(body.to_local(collision_point))
		
		# Get data for that tile
		var tile_data = body.get_cell_tile_data(tile_pos)
				
		if tile_data:
			var tile_color = tile_data.get_custom_data("color")
			if tile_color in color_sound_map:
				play_sound(color_sound_map[tile_color])

func play_sound(stream: AudioStream):
	# Use the current player to play this stream
	audio_players[current_player].stream = stream
	audio_players[current_player].play()
	
	# Now jump to the next player in line. 
  #Modulo loops it, so you're always within the bounds of the array.
	# (Thanks to Claude for this one too.)
	current_player = (current_player + 1) % max_audio_players
	
