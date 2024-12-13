extends Sprite2D
@onready var gradient_shine: Sprite2D = $GradientShine

# Here we're just creating a simple tween to create the 
# "shimmer" effect of that blue gradient passing along the
# outline of the shapes.

func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(gradient_shine, "position:x", 800, 3.0)
	tween.tween_property(gradient_shine, "position:x", -800, 3.0)
