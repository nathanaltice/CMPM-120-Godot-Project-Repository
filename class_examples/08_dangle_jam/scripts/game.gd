extends Node2D

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@export var base_speed: float = 120.0 
@onready var tempo_slider: HSlider = $TempoSlider

func _process(delta):
	path_follow.progress += (base_speed * tempo_slider.value )* delta
