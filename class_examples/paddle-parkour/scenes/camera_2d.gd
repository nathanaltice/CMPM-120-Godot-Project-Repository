# camera shake code from 'Godot 4 Camera Shake Tutorial': https://www.youtube.com/watch?v=LGt-jjVf-ZU

extends Camera2D

@export var randomStrength : float = 15
@export var shakeFade : float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0


func _ready() -> void:
	pass


func apply_shake():
	shake_strength = randomStrength


func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
