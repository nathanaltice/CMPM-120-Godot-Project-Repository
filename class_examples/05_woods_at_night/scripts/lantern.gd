extends PointLight2D

@export var min_energy := 0.9
@export var max_energy := 1.1
@export var flicker_time := 0.075


func _ready():
	# Use code to create a new timer
	var timer = Timer.new()
	# Add the timer to the scene
	add_child(timer)
	# Set the wait time
	timer.wait_time = flicker_time
	# Trigger the flicker(0 function on timeout
	timer.timeout.connect(flicker)
	# Start the timer.
	timer.start()


func flicker():
	# Set the energy of the light to a random float
	energy = randf_range(min_energy, max_energy)
