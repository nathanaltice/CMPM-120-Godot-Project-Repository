extends CharacterBody2D


const ROCKET_SPEED: float = 500.0
const MISSILE_SPEED: float = 10.0
var is_firing: bool = false
var screen_dimensions
var rocket_size


func _ready() -> void:
	screen_dimensions = get_window().size
	rocket_size = $Base.get_rect().size


func _physics_process(delta: float) -> void:
	handle_input()
	move_and_slide()
	#clamp_rocket_position()


func handle_input():
	if not is_firing:
		# handle fire button
		if Input.is_action_just_pressed("fire"):
			is_firing = true
			$ShotSFX.play()

		# handle left/right movement
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * ROCKET_SPEED
		else:
			velocity.x = 0
	# disable movement while firing
	else:
		$Missile.position.y -= MISSILE_SPEED
		velocity.x = 0


func clamp_rocket_position():
	position.x = clamp(position.x, 0 + rocket_size.x / 2, screen_dimensions.x - rocket_size.x / 2)


func reset_missile():
	$Missile.position.y = 0	# this works b/c missile position is relative to parent
	is_firing = false
	
