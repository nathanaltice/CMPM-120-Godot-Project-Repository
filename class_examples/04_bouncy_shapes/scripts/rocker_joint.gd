extends PinJoint2D

@export var rocker_color: Color = Color(255,0,0)

@onready var pin_sprite: Sprite2D = $Pin/PinSprite
@onready var curve_sprite: Sprite2D = $Curve/CurveSprite
@onready var bell_sound: AudioStreamPlayer2D = $BellSound
@onready var collision_polygon_2d: CollisionPolygon2D = $Curve/CollisionPolygon2D

func _ready() -> void:
	# Set the color of the sprites to your selected rocker_color
	pin_sprite.modulate = rocker_color
	curve_sprite.modulate = rocker_color


func _on_curve_body_entered(body: Node) -> void:
	# Play the sound when the curve is hit.
	bell_sound.play()
