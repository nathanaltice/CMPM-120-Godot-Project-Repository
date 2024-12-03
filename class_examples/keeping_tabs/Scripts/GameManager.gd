extends Node

# Class Notes: This class contains two ways to load a level. One is using the
# "load()" method to instantly load the resource and create a scene in one
# frame, and the other is using the resource loader to load the level resource
# over multiple frames. using "load()" or "preload()" is ok for a small
# project like this, but if you ever work on a large project that needs a long
# time to load scenes, you should use the ResourceLoader as used below.


# Constant Variables
const LEVEL_SCENE: String = "res://Scenes/Levels/Final Levels/Level 1.tscn"
const LOADING_SCENE: String = "res://Scenes/Levels/loading_screen.tscn"

# Loading Variables
var use_sub_threads: bool = false
var started_loading: bool = false
var progress: Array = []

# Level Variables
var current_level: Node = null
var current_is_loading: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start the first level
	load_loading_screen()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_loading_level()



func _loading_level() -> void:
	if(started_loading):
		var load_status = ResourceLoader.load_threaded_get_status(LEVEL_SCENE,
																  progress)
		match load_status:
			0: # ERROR
				print("Failed to Load, Error 0")
				started_loading = false
				
			1: # LOADING
				if(current_is_loading): # call down
					current_level.recieve_loading_percentage(progress[0])
			
			2: # ERROR
				print("Failed to Load, Error 2")
				started_loading = false
			
			3: # FINISHED LOAD
				current_level.recieve_loading_percentage(1.0)
				started_loading = false



# This function unloads the previous level.
func _unload_level():
	if(is_instance_valid(current_level)):
		
		# If the "next level" button signal exists, remove it. This is for
		# garbage collection.
		if(current_level.has_signal("start_loading_next_signal")):
			# Remove the signal to instantiate the next level
			if(current_level.finished_loading_signal.is_connected(load_new_level)):
				current_level.finished_loading_signal.disconnect(load_new_level)
		
		# If the "next level" button signal exists, remove it. This is for
		# garbage collection.
		if(current_level.has_signal("finished_loading_signal")):
			# Remove the signal to instantiate the next level
			if(current_level.finished_loading_signal.is_connected(instantiate_loaded_level)):
				current_level.finished_loading_signal.disconnect(instantiate_loaded_level)
		
		
		
		current_level.queue_free()
	current_level = null



# This function reloads the current level
func reload_level():
	# Get the level node
	var numNodes = get_child_count()
	var levelNode = get_child(numNodes - 1)
	
	# each node in the level has a script, so we can see if they have a respawn
	# method
	var children = levelNode.get_children()
	for child in children:
		# If a node can respawn, respawn it
		if child.has_method("respawn"):
			child.respawn()



func _load_level(level_path: String) -> void:
	var loading_state = ResourceLoader.load_threaded_request(level_path,
															 "",
															 use_sub_threads)
	
	if(loading_state == OK): # OK is just a stand in for "0". OK is used for detecting if something worked
		started_loading = true



func instantiate_loaded_level() -> void:
	# unload the previous level
	_unload_level()
	var loaded_level: Resource = ResourceLoader.load_threaded_get(LEVEL_SCENE)
	if(loaded_level):
		current_level = loaded_level.instantiate()
		add_child(current_level)



# This function loads an entirely new level using the ResourceLoader method.
func load_new_level():
	_load_level(LEVEL_SCENE)



# This function loads the loading screen level. This is the fast way to load a
# scene just using the "preload()" method.
func load_loading_screen() -> void:
	# unload the previous level
	_unload_level()
	
	# get the next level
	var loading_scene_resource = preload(LOADING_SCENE)
	
	# if the level is valid, load it
	if(loading_scene_resource):
		current_level = loading_scene_resource.instantiate()
		add_child(current_level)
		
		# get the method to update the loading bar
		if(current_level.has_method("recieve_loading_percentage")):
			current_is_loading = true
			
		# get the signal to start loading the next level
		if(current_level.has_signal("start_loading_next_signal")):
			current_level.start_loading_next_signal.connect(load_new_level)
			
		# get the signal to instantiate the next level
		if(current_level.has_signal("finished_loading_signal")):
			current_level.finished_loading_signal.connect(instantiate_loaded_level)
